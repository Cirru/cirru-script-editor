
caret = '\t'
input = '<input value="sdfsdf"/>'

isArr = Array.isArray
isStr = (item) -> (typeof item) is 'string'
found = (item) -> item.length > 0
empty = (item) -> item.length is 0
point = (item) ->
  (isStr item) and (item.indexOf caret) > -1
show = (args...) -> console.log.apply console, args
clear = (item) -> item.replace /\t/, ''
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
  insert_char list, ' '

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

exports.page_up = (list) -> list
exports.page_down = (list) -> list
exports.move_end = (list) -> list
exports.move_home = (list) -> list

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
        ret.push item[...(item.length-1)]
        ret.push caret
      else ret.push (move_right item)
  if mark then ret.push caret
  ret

exports.move_up = (list) -> list
exports.move_down = (list) -> list
exports.key_insert = (list) ->
  str = prompt() or ''
  insert_char list, str

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

exports.ctrl_m = (list) -> list
exports.ctrl_y = (list) -> list
exports.ctrl_p = (list) -> list