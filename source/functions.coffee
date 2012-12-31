
define (require, exports) ->

  caret = '\t'

  isArr = Array.isArray
  isStr = (item) -> (typeof item) is 'string'
  found = (item) -> item.length > 0
  empty = (item) -> item.length is 0
  point = (item) ->
    (isStr item) and (item.indexOf caret) > -1
  show = (args...) -> console.log.apply console, args
  clear = (item) ->
    if isStr item
      item.replace /\t/, ''
    else if isArr
      item.filter (x) -> x isnt caret
  isCell = (item) ->
    if isArr item
      if item.length is 1
        if item[0] is caret then yes
    no
  atHead = (item) ->
    if isStr item
      if item[0] is caret then return yes
    no
  inHead = (item) ->
    # show 'item', item
    if isArr item
      if item[0] is caret then return yes
    no
  last = (item) ->
    len = item.length
    item[len - 1]
  atTail = (item) ->
    if isStr item
      if (last item) is caret then return yes
    no
  inTail = (item) ->
    if isArr item
      if (last item) is caret then return yes
    no
  has_caret = (item) ->
    if isStr item then point item
    else if isArr item
      for x in item
        if (has_caret x) then return yes
      no
  exports.rm_caret  = rm_caret = (item) ->
    if isStr item then (clear item)
    else if isArr item
      ret = []
      item.forEach (x) ->
        piece = (rm_caret x)
        if found piece
          ret.push piece
      ret

  exports.insert_char = insert_char = (list, char) ->
    ret = []
    list.forEach (item) ->
      # show item
      if isStr item then ret.push item.replace(/\t/,"#{char}\t")
      else if isArr item then ret.push insert_char item, char
      else ret.push item
    ret

  exports.backspace = backspace = (list) ->
    ret = []
    list.forEach (item) ->
      # show item
      if item is caret
        if empty item then ret.push caret
        else 
          ret.pop()
          ret.push caret
      else if isStr item
        res = item.replace(/.{1}\t/, caret)
        # show item+'xx'
        # show res+'xx'
        ret.push res
      else if isCell item
        ret.push caret
      else if isArr then ret.push (backspace item)
    ret

  exports.insert_blank = (list) ->
    insert_char list, " "

  exports.create_block = create_block = (list) ->
    ret = []
    list.forEach (item) ->
      if isArr item
        ret.push (create_block item)
      else if (point item)
        # show "-#{item}-"
        if found (clear item) then ret.push (clear item)
        ret.push [caret]
      else ret.push item
    ret

  exports.spacebar = spacebar = (list) ->
    ret = []
    list.forEach (item) ->
      if isArr item
        ret.push (spacebar item)
      else if item is caret
        ret.push caret
      else if (point item)
        ret.push (clear item), caret
      else
         ret.push item
    ret

  exports.page_down = page_down =  (list) ->
    ret = []
    mark = off
    list.forEach (item) ->
      if mark
        if isArr item
          item.unshift caret
          ret.push item
        else if isStr item
          ret.push (caret.concat item)
        mark = off
      else if has_caret item
        mark = on
        piece = (rm_caret item)
        if found piece then ret.push piece
      else ret.push item
    if mark then ret.push [caret]
    ret

  exports.page_up = (list) ->
    list = page_down list.reverse()
    list.reverse()

  exports.move_home = move_home = (list) ->
    ret = []
    list.forEach (item) ->
      if isStr item
        if item is caret then ret.unshift caret
        else if atHead item
          ret.push caret
          if found item[1..] then ret.push item[1..]
        else if point item
          ret.push (caret.concat (clear item))
        else ret.push item
      else if isArr item
        if inHead item
          ret.push caret
          if found item[1..] then ret.push item[1..]
        else if caret in item
          piece = clear item
          piece.unshift caret
          ret.push piece
        else ret.push (move_home item)
    ret

  exports.move_end = move_end = (list) ->
    ret = []
    mark = off
    list.forEach (item) ->
      if isStr item
        if item is caret then mark = on
        else if atTail item then ret.push (clear item), caret
        else if point item then ret.push (clear item).concat(caret)
        else ret.push item
      else if isArr item
        if inTail item
          ret.push (clear item) if found (clear item)
          ret.push caret
        else if caret in item
          piece = clear item
          piece.push caret
          ret.push piece
        else ret.push (move_end item)
    if mark then ret.push caret
    ret

  exports.move_left = move_left = (list) ->
    ret = []
    list.forEach (item) ->
      # show 'each: ', item
      if item is caret
        # show 'caret'
        tail = ret.pop()
        if tail?
          if isArr tail
            tail.push caret
          else if isStr tail
            tail = tail.concat caret
          ret.push tail
        else ret.push caret
      else if inHead item
        # show 'inHead'
        ret.push caret
        item.shift()
        if found item then ret.push (move_left item)
      else if isArr item
        # show 'arr'
        ret.push (move_left item)
      else if atHead item
        # show 'string head', item
        ret.push caret, item[1..]
      else if point item
        # show 'point'
        ret.push (item.replace /(.)(\t)/, "$2$1")
      else
        # show 'else'
        ret.push item
    ret

  exports.move_right = move_right = (list) ->
    ret = []
    mark = off
    list.forEach (item) ->
      if item is caret then mark = on
      else if isStr item
        if mark
          ret.push (caret.concat item)
          mark = off
        else if atTail item
          ret.push item[...(item.length-1)], caret
        else ret.push item.replace(/(\t)(.)/,"$2$1")
      else if isArr item
        if mark
          item.unshift caret
          ret.push item
          mark = off
        else if inTail item
          piece = item[...(item.length-1)]
          if found piece then ret.push piece 
          ret.push caret
        else ret.push (move_right item)
    if mark then ret.push caret
    ret

  exports.move_up = move_up = (list) ->
    ret = []
    list.forEach (item) ->
      if isStr item
        if item is caret
          tail = ret.pop()
          if tail?
            if (isArr tail) and (not tail.every(isStr))
              tail.push caret
              ret.push tail
            else ret.push caret, tail
          else ret.push caret
        else if point item
          ret.push caret
          if found (clear item) then ret.push (clear item)
        else ret.push item
      else if isArr item
        if inHead item
          ret.push caret
          if found (clear item) then ret.push (clear item)
        else ret.push (move_up item)
    ret

  exports.move_down = move_down = (list) ->
    ret = []
    mark = off
    list.forEach (item) ->
      if isStr item
        if item is caret then mark = on
        else if point item
          if found (clear item) then ret.push (clear item)
          ret.push caret
        else ret.push item
      else if (isArr item)
        if mark and (not item.every(isStr))
          item.unshift caret
          ret.push item
          mark = off
        else if inTail item
          if found (clear item) then ret.push (clear item)
          ret.push caret
        else ret.push (move_down item)
    if mark then ret.push caret
    ret

  exports.key_delete = key_delete = (list) ->
    ret = []
    list.forEach (item) ->
      if item is caret
        # show 'caret'
        tail = ret.pop()
        ret.push (if tail? then (tail.concat caret) else caret)
      else if point item
        # show 'point', item
        ret.push caret
      else if isCell item
        # show 'cell'
        ret.push caret
      else if isArr item
        # show 'arr'
        ret.push (key_delete item)
      else ret.push item
    ret

  exports.ctrl_x = ctrl_x = (list) ->
    ret = []
    list.forEach (item) ->
      if isStr item
        if point item
          window.cirru_copyboard = item
          ret.push caret
        else ret.push item
      else if isArr item
        if caret in item
          window.cirru_copyboard = item
          ret.push caret
        else ret.push (ctrl_x item)
    ret

  exports.ctrl_c = ctrl_c = (list) ->
    list.forEach (item) ->
      if isStr item
        # show item
        if point item
          window.cirru_copyboard = item
      else if isArr item
        if caret in item
          window.cirru_copyboard = item
        else ctrl_c item
    list

  exports.ctrl_v = ctrl_v = (list) ->
    ret = []
    list.forEach (item) ->
      if isStr item
        if point item
          if window.cirru_copyboard?
            if found (clear item) then ret.push (clear item)
            ret.push window.cirru_copyboard
          else ret.push item
        else ret.push item
      else if isArr item
        ret.push (ctrl_v item)
    ret

  exports.ctrl_z = (his) ->
    len = his.all.length
    if his.now > 0 then his.now -= 1
    # show 'z:', his
    ret = his.all[his.now]
    # show 'ret: ', ret, his.now
    ret

  exports.ctrl_y = (his) ->
    len = his.all.length
    if len > (his.now + 1) then his.now += 1
    # show 'y:', his
    ret = his.all[his.now]
    # show ret
    ret

  exports.add_history = (his, list) ->
    his.all.push list
    his.now += 1
    # show 'add:', his
    his.all = his.all[..his.now]
    if his.all.length > 1000
      his.all.shift()
      his.now -= 1
    his

  exports.reset_history = (his, list) ->
    his.all = [list]
    his.now = 0
    his

  return