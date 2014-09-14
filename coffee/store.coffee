
Dispatcher = require './utils/dispatcher'

mixin = (obj, proto) ->
  for key, value of proto
    obj[key] = value
  obj

module.exports = new Dispatcher

mixin module.exports,
  data:
    ast: [
      ['set', '', '1']
      ['print', ['+', 'x', 'y']]
      ['set', ['get', 'a'], ['string', 'a b c']]
    ]

  getAST: ->
    @data.ast