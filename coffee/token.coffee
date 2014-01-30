
define (require, exports) ->

  {Unit} = require 'unit'

  class Token extends Unit
    type: 'Token'
    constructor: (@parent) ->
      super()

    getEntryStart: (caret) ->
      entry: caret.pointer.parent
      start: caret.pointer.selfLocate()

  {Token}