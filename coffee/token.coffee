
define (require, exports) ->

  {Unit} = require 'unit'

  class Token extends Unit
    type: 'Token'
    constructor: (@parent) ->
      super()

  {Token}