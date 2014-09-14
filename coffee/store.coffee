
Dispatcher = require './utils/dispatcher'

mixin = (obj, proto) ->
  for key, value of proto
    obj[key] = value
  obj

module.exports = new Dispatcher

mixin module.exports,
  data:
    ast: {}

  getAST: ->
    @data.ast