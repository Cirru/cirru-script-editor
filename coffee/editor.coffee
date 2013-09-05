
{proto} = require 'proto-scope' 
dom = require './dom.coffee'
utils = require './utils.coffee'
{events} = require 'proto-events'
{$} = require 'zepto-browserify'

template = {}
utils.delay 100, ->
  body = dom.q('.cirru-template').import.body
  template.editor = body.querySelector('.cirru-editor')
  template.cell = body.querySelector('.cirru-cell')

event_view = events.as
  remove: ->
    @el.removeEventListener()
    @el.remove()
  $: (query) ->
    $(@el).find query
  init: ->
    @bindEvents()
    @super()
  bindEvents: ->
    if @events? and @el?
      for key, value of @events
        {base, query} = utils.parseElement key
        $($el).on ''

cell = event_view.as
  init: ->
    @super()
    @el = template.cell.cloneNode yes
    @bindEvents()

exports.editor = event_view.as
  init: ->
    @super()
    @el = template.editor.cloneNode yes
    @$el = $ @el