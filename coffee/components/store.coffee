
uuid = require 'uuid'

createSequence = (parent) ->
  id: uuid.v4()
  data: []
  type: 'sequence'
  parent: parent

createToken = (parent, text) ->
  id: uuid.v4()
  data: text
  token: token
  parent: parent

ast = createSequence null
ast.id = 'root'
caret =
  buffer: ''
  ast: ast
  index: 0

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
        x

    getData ast

  importData: (data) ->
    expandData = (x, parent) ->
      if typeof x is 'string'
        createToken parent, x
      else
        createSequence x

    ast = expandData data
    ast.id = 'root'

    caret.ast = ast
    caret.index = 0
    caret.buffer = ''

    @emit()

  typeInCaret: (text) ->
    if text is '\n'
      @newSequenceFromCaret()
    else
      @newTokenFromCaret text

  newSequenceFromCaret: ->
    sequence = createSequence caret.ast
    index = caret.index
    caret.ast.data.splice index, 0, sequence
    caret.index = 0
    caret.buffer = ''
    caret.ast = sequence
    @emit()

  newTokenFromCaret: (text) ->
    token = createToken caret.ast, text
    caret.ast.data.splice index, 0, token
    caret.index = 0
    caret.buffer = ''
    caret.ast = token
    @emit()

  newTokenFromToken: ->

  newSequenceFromToken: ->
    sequence = createSequence caret.ast
    if caret.ast.data.length > 0
      index = caret.index + 1
    else
      index = caret.index
    caret.ast.data.splice index, 0, sequence
    caret.index = 0
    caret.buffer = ''
    caret.ast = sequence
    @emit()

  removeToken: ->

  removeNode: ->
