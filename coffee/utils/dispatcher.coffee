
module.exports = class Dispacher
  constructor: ->
    @_queue = []

  addChangeListener: (cb) ->
    unless cb in @_queue
      @_queue.push cb

  emit: ->
    for cb in @_queue
      cb()

  removeChangeListener: (f) ->
    for cb, index in @_queue
      if cb is f
        @_queue.splice index, 1
        break