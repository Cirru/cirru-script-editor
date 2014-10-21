
uuid = require 'uuid'
query = require '../util/query'

createSequence = (parent) ->
  type: 'sequence'
  id: uuid.v4()
  parent: parent
  data: []

createToken = (parent, text) ->
  type: 'token'
  id: uuid.v4()
  parent: parent
  data: text

ast = createSequence null
ast.id = 'root'
caret =
  buffer: ''
  ast: ast
  index: 0
  nth: 0
  candidates: []

updateCaret = (target, index, buffer, nth) ->
  # console.log 'caret:', target, index, buffer
  caret.ast = target
  caret.index = index
  caret.buffer = buffer
  caret.nth = nth or 0

module.exports =
  getAst: ->
    ast

  getCaret: ->
    caret

  exportData: ->
    getData = (x) ->
      if x.type is 'sequence'
        x.data.map getData
      else
        x.data

    getData ast

  importData: (data) ->
    expandData = (x, parent) ->
      if typeof x is 'string'
        createToken parent, x
      else
        sequence = createSequence parent
        sequence.data = x.map (item, index) ->
          expandData item, sequence
        sequence

    ast = expandData data, null
    console.log 'after import', ast
    ast.id = 'root'

    # updateCaret ast, 0, ''

    @emit()

  typeInCaret: (text) ->
    if text[0] is '\n'
      @newSequenceFromCaret()
    else
      if text.length > 0
        @newTokenFromCaret text

  newSequenceFromCaret: ->
    sequence = createSequence caret.ast
    index = caret.index
    caret.ast.data.splice index, 0, sequence
    updateCaret sequence, 0, ''
    @emit()

  newTokenFromCaret: (text) ->
    token = createToken caret.ast, text
    index = caret.index
    caret.ast.data.splice index, 0, token
    updateCaret token, index, text
    @generateComplete()
    @emit()

  newCaretFromToken: ->
    target = caret.ast.parent
    index = (target.data.indexOf caret.ast) + 1
    updateCaret target, index, ''
    @emit()

  removeToken: ->
    if caret.ast.data.length is 0
      target = caret.ast.parent
      index = (target.data.indexOf caret.ast)
      updateCaret target, index, ''
      target.data.splice index, 1
      @emit()

  removeNode: ->
    if caret.index is 0
      if caret.ast.id isnt 'root'
        target = caret.ast.parent
        index = target.data.indexOf caret.ast
        target.data.splice index, 1
        updateCaret target, index, ''
        @emit()
    else
      index = caret.index - 1
      caret.ast.data.splice index, 1
      updateCaret caret.ast, index, ''
      @emit()

  caretFocus: (target) ->
    updateCaret target, 0, target.data
    @generateComplete()
    @emit()

  updateToken: (text) ->
    if caret.ast.type is 'token'
      caret.ast.data = text
      updateCaret caret.ast, 0, text
      @generateComplete()
      @emit()

  caretLeft: ->
    if caret.index is 0
      if caret.ast.parent?
        target = caret.ast.parent
        index = target.data.indexOf caret.ast
        updateCaret target, index, ''
        @emit()
    else
      index = caret.index - 1
      target = caret.ast.data[index]
      if target.type is 'sequence'
        updateCaret target, target.data.length, ''
        @emit()
      else
        updateCaret caret.ast, index, ''
        @emit()

  caretRight: ->
    if caret.index is caret.ast.data.length
      if caret.ast.parent?
        target = caret.ast.parent
        index = (target.data.indexOf caret.ast) + 1
        updateCaret target, index, ''
        @emit()
    else
      index = caret.index + 1
      target = caret.ast.data[caret.index]
      if target.type is 'sequence'
        updateCaret target, 0, ''
        @emit()
      else
        updateCaret caret.ast, index, ''
        @emit()

  caretUp: ->
    if caret.index > 0
      updateCaret caret.ast, 0, ''
      @emit()
    else
      if caret.ast.parent?
        target = caret.ast.parent
        index = target.data.indexOf caret.ast
        updateCaret target, index, ''
        @emit()

  caretDown: ->
    if caret.index < caret.ast.data.length
      updateCaret caret.ast, caret.ast.data.length, ''
      @emit()
    else
      if caret.ast.parent?
        target = caret.ast.parent
        index = (target.data.indexOf caret.ast) + 1
        updateCaret target, index, ''
        @emit()

  dropAt: (target) ->
    item = caret.ast
    if target.type is 'sequence'
      parent = item.parent
      index = parent.data.indexOf item
      parent.data.splice index, 1
      target.data.unshift item
      item.parent = target
      @emit()
    else # 'token'
      dest = target.parent
      origin = item.parent
      originIndex = origin.data.indexOf item
      origin.data.splice originIndex, 1
      item.parent = dest
      index = (dest.data.indexOf target) + 1
      dest.data.splice index, 0, item
      @emit()

  generateComplete: ->
    text = caret.buffer
    candidates = []
    recursiveFind = (ast) =>
      if ast.type is 'token'
        if ast.id isnt caret.ast.id
          if query.fuzzy ast.data, text
            unless ast.data in candidates
              candidates.push ast.data
      else
        ast.data.map recursiveFind
    recursiveFind ast
    caret.candidates = candidates.sort (x, y) ->
      x.length - y.length
    caret.nth = 0

  moveNthUp: ->
    if caret.candidates.length > 1
      if caret.nth is 0
        caret.nth = caret.candidates.length - 1
      else
        caret.nth -= 1
      @emit()

  moveNthDown: ->
    if caret.candidates.length > 1
      if caret.nth is (caret.candidates.length - 1)
        caret.nth = 0
      else
        caret.nth += 1
      @emit()

  complete: ->
    caret.ast.data = caret.candidates[caret.nth]
    caret.buffer = caret.candidates[caret.nth]
    @generateComplete()
    @emit()