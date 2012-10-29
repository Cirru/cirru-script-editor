
define (require, exports) ->

  # $ = require '../lib/jquery/1.8.1/jquery.js'
  show = (args...) -> console.log.apply console, args

  input = '<input id="input"/>'
  copy = (json) -> JSON.parse (JSON.stringify json)

  exports.editor = (id) ->

    elem = document.querySelector "##{id}"

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
    } = require './functions'

    tool =
      err: (info) -> throw new Error info

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

    ret.__defineGetter__ 'value', -> rm_caret list

    render = require('./renderer').render

    ret.render = do_render = ->
      # show 'do_render', on_update
      # show 'li:', list
      render list, elem
      set_local (JSON.stringify value: list)

    elem.onclick = (e) ->
      focused = yes
      fd = 'cirru-focused'
      if elem.className.indexOf(fd) < 0
        elem.className = elem.className + ' ' + fd
      e.stopPropagation()

    window.onclick = ->
      focused = no
      fd = 'cirru-focused'
      if elem.className.indexOf(fd) >= 0
        elem.className = elem.className.replace(fd, '').replace /\s+$/, ''

    alpha = 'qwertyuiopasdfghjklzxcvbnm'
    all = '`1234567890-=~!@#$%^&*()_+ '
    all+= alpha
    all+= alpha.toUpperCase()
    all+= '[]\\{}|;:"\',./<>?'
    all = all.split ''

    document.body.onkeypress = (e) ->
      # show focused, e.keyCode
      # char = String.fromCharCode e.keyCode
      # show 'char from press -', char
      if focused
        char = String.fromCharCode e.keyCode
        if char in all
          list = insert_char list, char
          history = add_history (copy history), (copy list)
          do_render()

    choice = require('./control').choice

    document.body.onkeydown = (e) ->
      if focused
        code = e.keyCode
        show code, e
        unless e.ctrlKey
          if choice[code]?
            list = choice[code] list
            history = add_history (copy history), (copy list)
            do_render()
            e.preventDefault()
        else
          if code is 80 then return key_ctrl_p()
          else if code is 88 then return key_ctrl_x()
          else if code is 67 then return key_ctrl_c()
          else if code is 86 then return key_ctrl_v()
          else if code is 90 then return key_ctrl_z()
          else if code is 89 then return key_ctrl_y()

    key_ctrl_p = ->
      # str = prompt() or ''
      # insert_char list, str
      if focused
        document.querySelector('#caret').after(input).remove()
        # show focused
        focused = no
        document.querySelector('#input').focus().onkeydown = (e) ->
          if e.keyCode is 13
            focused = yes
            # show '13', focused
            list = insert_char list, document.querySelector('#input').value
            do_render()
            e.preventDefault()
            # show list
            off
        off

    key_ctrl_x = ->
      show 'control x'
      list = ctrl_x list
      do_render()
      off
    key_ctrl_c = ->
      list = ctrl_c list
      do_render()
      off
    key_ctrl_v = ->
      list = ctrl_v list
      do_render()
      off
    key_ctrl_z = ->
      # show 'z:', history
      list = ctrl_z history
      do_render()
      off
    key_ctrl_y = ->
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