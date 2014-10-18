
uuid = require 'uuid'

store =
  caret:
    buffer: ''
    pointer: null
    index: 0
  ast:
    id: 'root'
    data: []
    type: 'sequence'
    parent: null

store.caret.pointer = store.ast.id

module.exports =
  getAst: ->
    store.ast

  getCaret: ->
    store.caret

  exportData: ->
    getData = (x) ->
      if x.type is 'sequence'
        x.data.map getData
      else
        x

    getData store.ast

  importData: (data) ->
    expandData = (x, parent) ->
      if typeof x is 'string'
        id: uuid.v4()
        parent: parent
        data: x
        type: 'token'
      else
        id: uuid.v4()
        parent: parent
        data: x
        type: 'sequence'

    store.ast = expandData data
    store.ast.id = 'root'

    store.caret.pointer = 'root'
    store.caret.index = 0
    store.caret.buffer = ''

    @emit()