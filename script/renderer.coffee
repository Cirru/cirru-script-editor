
isArr = Array.isArray
isStr = (item) -> (typeof item) is 'string'

escape = (item) -> item.replace /\s/g, '&nbsp;'

caret = '<span id="caret"></span>'

draw = (list) ->

  html = ''

  list.forEach (item) ->
    html +=
      if isArr item then draw item
      else if isStr item
        "<code>#{item.replace /\t/, caret}</code>"
      else "<code>#{escape item}</code>"

  "<pre>#{html}</pre>"

exports.render = (list, elem) ->
  elem.html (draw list)