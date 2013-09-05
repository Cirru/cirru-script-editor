
{proto} = require 'proto-scope' 
dom = require './dom.coffee'
utils = require './utils.coffee'
{events} = require './events.coffee'

template = {}
utils.delay 100, ->
  body = dom.q('.cirru-template').import.body
  template.editor = body.querySelector('.cirru-editor')
  template.cell = body.querySelector('.cirru-cell')

cell = events.as
  init: ->
    @__proto__.init()
    @el = template.cell.cloneNode yes
  remove: ->
    @el.removeEventListener()
    @el.remove()

exports.editor = events.as
  init: ->
    @__proto__.init()
    @el = template.editor.cloneNode yes    
  remove: ->
    @el.removeEventListener()
    @el.remove()