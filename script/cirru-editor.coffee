
define (require, exports) ->

  $ = require '../lib/jquery/1.8.1/jquery.js'
  show = (args...) -> console.log.apply console, args

  input = '<input id="input"/>'
  copy = (json) -> JSON.parse (JSON.stringify json)

  exports.editor = (id) ->

    elem = $ "##{id}"

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
    focused = no
    history =
      all: [['\t']]
      now: 0

    set_local = (str) ->
      localStorage["cirru.#{id}"] = str
    get_local = ->
      localStorage["cirru.#{id}"]

    ret.reset_history = (list) ->
      history = reset_history history, list

    ret.val = (value) ->
      if value? then list = value
      else list

    ret.value = -> rm_caret list

    render = require('./renderer.coffee').render

    ret.render = do_render = ->
      # show 'do_render', on_update
      # show 'li:', list
      render list, elem
      set_local (JSON.stringify value: list)

    elem.click (e) ->
      focused = yes
      e.preventDefault()
      elem.addClass 'cirru-focused'
      off

    $(window).click ->
      focused = no
      elem.removeClass 'cirru-focused'

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

    key.down 'ctrl p', ->
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

    list =
      if get_local()? then (JSON.parse get_local()).value
      else
        set_local (JSON.stringify value: ['\t'])
        ['\t']

    ret.render()
    ret.reset_history list

    elem.click()
      
    ret

  return