
exports.editor = (elem) ->

  tool =
    err: (info) -> throw new Error info

  do check = ->
    unless $? then tool.err 'I need jQuery!'
    unless elem? then tool.err 'need a elem!'

  ret = {}
  input = '<input id="input"/>'

  list = ['\t']
  elem = $(elem)

  focused = no

  ret.val = (value) ->
    if value? then list = value
    else list

  render = require('./renderer.js').render

  on_update = []
  ret.update = (f) -> on_update.push f

  ret.render = do_render = ->
    # show 'do_render', on_update
    render list, elem
    on_update.forEach (f) -> f()

  elem.click (e) ->
    focused = yes
    elem.css opacity: 1
    e.preventDefault()
    off

  $(window).click ->
    elem.css opacity: 0.4
    focused = no

  {
    insert_char
    insert_blank
    move_left
    move_right
    move_up
    move_down
    create_block
    ctrl_m
    ctrl_y
    ctrl_p
  } = require './functions.js'

  alphabet = require('./alphabet.js').all

  $('body').keypress (e) ->
    # show focused, e.keyCode
    # char = String.fromCharCode e.keyCode
    # show 'char from press -', char
    if focused
      char = String.fromCharCode e.keyCode
      if char in alphabet
        list = insert_char list, char
        do_render()

  choice = require('./control.js').choice

  $('body').keydown (e) ->
    if focused
      code = e.keyCode
      # show code
      if choice[code]?
        list = choice[code] list
        do_render()
        e.preventDefault()

  key = new Kibo

  key.down 'ctrl i', ->
    # str = prompt() or ''
    # insert_char list, str
    if focused
      $('#caret').after(input).remove()
      # show focused
      focused = no
      $('#input').focus().keydown (e) ->
        if e.keyCode is 13
          focused = yes
          # show '13', focused
          list = insert_char list, $('#input').val()
          do_render()
          e.preventDefault()
          # show list
          off
      off

  key.down 'ctrl m', ->
    list = ctrl_m list
    do_render()
    off
  key.down 'ctrl y', ->
    list = ctrl_y list
    do_render()
    off
  key.down 'ctrl p', ->
    list = ctrl_p list
    do_render()
    off
  ret