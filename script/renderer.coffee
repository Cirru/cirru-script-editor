
define (require, exports) ->

  # show = (args...) -> console.log.apply console, args
  show = ->

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
    elem.innerHTML = draw list
    caret_elem = elem.querySelector('#caret')
    top = caret_elem.offsetTop - elem.offsetTop
    height = elem.offsetHeight
    scrollTop = elem.scrollTop
    show caret_elem.offsetTop, elem.offsetTop, scrollTop
    unless (top > scrollTop) and (top < scrollTop + height)
      elem.scrollTop = top - height/2

  return