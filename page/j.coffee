  
$ ->
  editable = 'contenteditable'
  capet = "<code id='target' #{editable}='true'/>"
  blank = ['', '<br>']
  paste = ''

  p = -> $ '#point'
  t = -> $ '#target'

  empty = (elem) -> elem.html() in blank
  root = (elem) -> elem.parent().attr('id') is 'editor'
  exist = (elem) -> elem.length > 0
  leaf = (elem) -> elem[0].tagName is 'CODE'

  target = (elem) ->
    elem.attr('id', 'point').attr(editable, 'true')

  point = (refocus = yes) ->
    old = p().removeAttr('id').removeAttr editable
    if exist old
      old.html (old.html().replace /\<br\>/g, '')
      old[0].onclick = (e) ->
        old.attr('id', 'target').attr(editable, 'true')
        point off
        e.stopPropagation()
      while empty old
        up = old.parent()
        old.remove()
        old = up
        if root old
          if empty old then old.remove()
          break
    target t()
    if refocus then focus()

  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    $('div').addClass 'inline'
    $('div:has(div)').removeClass 'inline'
    p().focus()

  $('#editor').append capet
  t().attr 'id', 'point'
  focus()
  $('#editor')[0].onclick = (e) ->
    focus()
    e.stopPropagation()
    parse()

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no

  $('#editor').keydown (e) ->
    # console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13
          p().after "<div>#{capet}</div>"
          next = p().next()
          next[0].onclick = (e) ->
            next.append capet
            point()
            e.stopPropagation()
        when 9 then p().after capet
        when 46 # key delete
          if exist p().prev()
            it = p().prev()
            if leaf it then it.attr 'id', 'target'
            else it.append capet
          else if exist p().next()
            it = p().next()
            if leaf it then it.attr 'id', 'target'
            else it.prepend capet
          else unless root p()
            p().parent().after(capet).remove()
          else unless p().html() in blank then p().after capet
          else return on
          p().remove()
        when 38 # up
          unless p().html() in blank then p().before capet
          else if exist p().prev()
            prev = p().prev()
            if leaf prev then prev.attr 'id', 'target'
            else prev.append capet  
          else unless root p() then p().parent().before capet
          else return off
        when 40 # down
          unless p().html() in blank then p().after capet
          else if exist p().next()
            next = p().next()
            if leaf next then next.attr 'id', 'target'
            else next.prepend capet  
          else unless root p() then p().parent().after capet
          else return off
        when 219 # ctrl + [
          if e.ctrlKey and (not (root p()))
            up = p().parent()
            up.after capet
            point()
            console.log up.parent()
            paste = up[0].innerHTML or ''
            up.remove()
          return on
        when 221 # ctrl + ]
          if e.ctrlKey and paste.length > 0
            p().before paste
          return on
        when 33 # pgup
          unless root p() then p().parent().before capet
          else return on
        when 34 # pgdown
          unless root p() then p().parent().after capet
          else return on
        else return on
      point()
    e.stopPropagation()
    off

  parse = ->
    map = (item, b) ->
      if leaf [item] then item.innerText
      else [$.map item.children, (x) -> map x]
    res = $.map $('#editor')[0].children, map
    console.log 'res:', res