
{proto} = require 'proto-scope'
# rewrite based on https://gist.github.com/Contra/2759355

exports.events = proto.as
  init: ->
    @events = {}
 
  emit: (event, args...) ->
    if @events[event]?
      listener args... for listener in @events[event]
      yes
    else no
 
  addListener: (event, listener) ->
    @emit 'newListener', event, listener
    (@events[event]?=[]).push listener
    @
 
  once: (event, listener) ->
    fn = =>
      @removeListener event, fn
      listener arguments...
    @on event, fn
    @
 
  removeListener: (event, listener) ->
    if @events[event]
      @events[event] = (l for l in @events[event] when l isnt listener)
    @
 
  removeAllListeners: (event) ->
    delete @events[event]
    @
 
  on: (args...) ->
    @addListener args...

  off: (event) ->
    @removeListener event