
define (require, exports) ->

  # show = (args...) -> console.log.apply console, args
  show = ->

  isArr = Array.isArray
  isStr = (item) -> (typeof item) is 'string'
  notArr = (item) -> not (isArr item)

  caret = '<span id="caret"> </span>'

  escape = (item) ->
    show "escape"
    item.replace /\s/g, '&nbsp;'
  visual = (item) ->
    string = ""
    item.split("").forEach (char) ->
      switch char
        when " " then string += "➭"
        when "\t" then string += caret
        else string += char
    string

  exports.draw = draw = (list, compact) ->

    html = ''
    inline = ""
    if (list.every notArr) and compact
      inline = ' class="inline"'

    list.forEach (item) ->
      compact_child = list.length < 6
      # console.log  'compact?:', item, compact

      show "item:", item
      html +=
        if isArr item then draw item, compact_child
        else if isStr item
          if item is "\t" then caret
          else "<code>#{visual item}</code>"
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