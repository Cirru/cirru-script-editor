
uuid = require 'uuid'

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

updateCaret = (target, index, buffer) ->
  console.log 'caret:', target, index, buffer
  caret.ast = target
  caret.index = index
  caret.buffer = buffer

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
        createSequence parent

    ast = expandData data, null
    ast.id = 'root'

    updateCaret ast, 0, ''

    @emit()

  typeInCaret: (text) ->
    if text.length > 0
      if text is '\n'
        @newSequenceFromCaret()
      else
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
    updateCaret token, index, ''
    @emit()

  newCaretFromToken: ->
    target = caret.ast.parent
    index = (target.data.indexOf caret.ast) + 1
    updateCaret target, index, ''
    console.log 'set caret at sequence', target, index
    @emit()

  newSequenceFromToken: ->
    sequence = createSequence caret.ast.parent
    target = caret.ast.parent
    index = (target.data.indexOf caret.ast) + 1
    target.data.splice index, 0, sequence
    updateCaret sequence, 0, ''
    @emit()

  removeToken: ->
    console.log caret.ast
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
    updateCaret target, 0, ''
    @emit()

  updateToken: (text) ->
    if caret.ast.type is 'token'
      caret.ast.data = text
      updateCaret caret.ast, 0, text
      @emit()