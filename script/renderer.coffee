
define (require, exports) ->

  $ = require '../lib/jquery/1.8.1/jquery.js'

  isArr = Array.isArray
  isStr = (item) -> (typeof item) is 'string'
  notArr = (item) -> not (isArr item)

  escape = (item) -> item.replace /\s/g, '&nbsp;'

  caret = '<span id="caret"> </span>'

  exports.draw = draw = (list, compact) ->

    html = ''
    inline =
      unless (list.every notArr) and compact then ''
      else ' class="inline"'

    list.forEach (item) ->
      compact_child = (list.length < 7)
      # console.log  'compact?:', item, compact

      html +=
        if isArr item then draw item, compact_child
        else if isStr item
          "<code>#{item.replace /\t/, caret}</code>"
        else "<code>#{escape item}</code>"

    "<pre#{inline}>#{html}</pre>"

  exports.render = (list, elem) ->
    # console.log list
    elem.html (draw list)
    top = $('#caret').offset().top
    height = elem.innerHeight()
    base = elem.offset().top
    scrollTop = elem.scrollTop()
    # show 'height:', top, height, base, scrollTop
    unless (top > base) and (top < base + height)
      elem.animate scrollTop: (scrollTop + top - base - height/2), 200

  return