
define (require, exports) ->

  $ = require '../lib/jquery/1.8.1/jquery.js'

  input = '<input id="input"/>'
  copy = (json) -> JSON.parse (JSON.stringify json)

  exports.editor = (elem) ->

    {
      insert_char
      insert_blank
      move_left
      move_right
      move_up
      move_down
      create_block
      ctrl_x
      ctrl_c
      ctrl_v
      ctrl_z
      ctrl_y
      add_history
      reset_history
      rm_caret
    } = require './functions.coffee'

    tool =
      err: (info) -> throw new Error info

    do check = ->
      unless $? then tool.err 'I need jQuery!'
      unless elem? then tool.err 'need a elem!'

    ret = {}

    list = [['\t']]
    elem = $(elem)
    focused = no
    history =
      all: [['\t']]
      now: 0

    ret.reset_history = (list) ->
      history = reset_history history, list

    ret.val = (value) ->
      if value? then list = value
      else list

    ret.value = -> rm_caret list

    render = require('./renderer.coffee').render

    on_update = []
    ret.update = (f) -> on_update.push f

    ret.render = do_render = ->
      # show 'do_render', on_update
      # show 'li:', list
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

    alpha = 'qwertyuiopasdfghjklzxcvbnm'
    all = '`1234567890-=~!@#$%^&*()_+ '
    all+= alpha
    all+= alpha.toUpperCase()
    all+= '[]\\{}|;:"\',./<>?'
    all = all.split ''

    $('body').keypress (e) ->
      # show focused, e.keyCode
      # char = String.fromCharCode e.keyCode
      # show 'char from press -', char
      if focused
        char = String.fromCharCode e.keyCode
        if char in all
          list = insert_char list, char
          history = add_history (copy history), (copy list)
          do_render()

    choice = require('./control.coffee').choice

    $('body').keydown (e) ->
      if focused
        code = e.keyCode
        # show code
        if choice[code]?
          list = choice[code] list
          history = add_history (copy history), (copy list)
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

    key.down 'ctrl x', ->
      list = ctrl_x list
      do_render()
      off
    key.down 'ctrl c', ->
      list = ctrl_c list
      do_render()
      off
    key.down 'ctrl v', ->
      list = ctrl_v list
      do_render()
      off
    key.down 'ctrl z', ->
      # show 'z:', history
      list = ctrl_z history
      do_render()
      off
    key.down 'ctrl y', ->
      list = ctrl_y history
      do_render()
      off
      
    ret

  return