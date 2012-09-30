
caret = '\t'
isArr = Array.isArray
isStr = (item) -> (typeof item) is 'string'
found = (item) -> item.length > 0
empty = (item) -> item.length is 0
point = (item) -> (item.indexOf caret) > -1
show = (args...) -> console.log.apply console, args

exports.insert_char = insert_char = (list, char) ->
  ret = []
  list.forEach (item) ->
    if isStr item then ret.push item.replace(/\t/,"#{char}\t")
    else if isArr item then ret.push insert_char item, char
    else ret.push item
  ret

exports.backspace = backspace = (list) ->
  ret = []
  list.forEach (item) ->
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
    else if isArr then ret.push (backspace item)
  ret

exports.insert_blank = (list) ->
  insert_char list, ' '

exports.create_block = (list) -> list
exports.spacebar = (list) -> list
exports.page_up = (list) -> list
exports.page_down = (list) -> list
exports.move_end = (list) -> list
exports.moe_end = (list) -> list
exports.move_left = (list) -> list
exports.move_right = (list) -> list
exports.move_up = (list) -> list
exports.move_down = (list) -> list
exports.key_insert = (list) -> list
exports.key_delete = (list) -> list
exports.ctrl_m = (list) -> list
exports.ctrl_y = (list) -> list
exports.ctrl_p = (list) -> list