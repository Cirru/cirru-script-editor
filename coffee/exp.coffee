
define (require, exports) ->

  {Unit} = require 'unit'
  {Token} = require 'token'

  class Exp extends Unit
    type: 'Exp'
    constructor: (@parent) ->
      super()

    makeToken: ->
      new Token @

    makeExp: ->
      new Exp @

    getItem: (index) ->
      @list[index]

  {Exp}