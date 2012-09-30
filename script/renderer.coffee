
isArr = Array.isArray
isStr = (item) -> (typeof item) is 'string'
notArr = (item) -> not (isArr item)

escape = (item) -> item.replace /\s/g, '&nbsp;'

caret = '<span id="caret"> </span>'

draw = (list) ->

  html = ''
  inline = ''

  list.forEach (item) ->
    html +=
      if isArr item then draw item
      else if isStr item
        "<code>#{item.replace /\t/, caret}</code>"
      else "<code>#{escape item}</code>"

  if list.every notArr then inline = ' class="inline"'

  if inline then 
  "<pre#{inline}>#{html}</pre>"

exports.render = (list, elem) ->
  console.log list
  elem.html (draw list)