  
cirru = ->
  unless $? then alert 'Where s my jQuery!?'

  editable = 'contenteditable'
  caret = "<code id='target' #{editable}='true'/>"
  menu = '<footer id="menu"></footer>'
  blank = ['', '<br>']
  paste = ''

  window.p = -> $ '#point'
  window.t = -> $ '#target'
  window.m = -> $ '#menu'
  window.s = -> $ '#sel'
  window.c = -> $ '#cirru'

  empty = (elem) -> elem.html() in blank
  root = (elem) -> elem.parent().attr('id') is 'cirru'
  exist = (elem) -> elem.length > 0
  leaf = (elem) -> elem[0].tagName is 'CODE'
  text = (elem) -> elem.html().replace /<br>/g, ''

  point = (refocus = yes) ->
    aval = []
    old = p().removeAttr('id').removeAttr editable
    if exist old
      old.html (text old)
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
    t().attr('id', 'point').attr(editable, 'true')
    if refocus then focus()
    put()

  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    $('div').addClass 'inline'
    $('div:has(div)').removeClass 'inline'
    p().focus()

  in_sight = yes
  c().bind 'focus', -> in_sight = yes
  c().bind 'blur', -> in_sight = no

  c().keydown (e) ->
    console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13 # key enter
          if exist s()
            p().html (text s())
            s().removeAttr 'id'
            focus()
            return off
          else
            p().after "<div>#{caret}</div>"
            next = p().next()
            next[0].onclick = (e) ->
              next.append caret
              point()
              e.stopPropagation()
        when 9 # key tab
          if exist s() then p().html (text s())
          if e.shiftKey then p().before caret
          else p().after caret
        when 46 # key delete
          if exist p().prev()
            it = p().prev()
            if leaf it then it.attr 'id', 'target'
            else it.append caret
          else if exist p().next()
            it = p().next()
            if leaf it then it.attr 'id', 'target'
            else it.prepend caret
          else unless root p()
            p().parent().after(caret).remove()
          else unless p().html() in blank then p().after caret
          else return on
          p().remove()
        when 38 # up
          unless p().html() in blank then p().before caret
          else if exist p().prev()
            prev = p().prev()
            if leaf prev then prev.attr 'id', 'target'
            else prev.append caret  
          else unless root p() then p().parent().before caret
          else return off
        when 40 # down
          unless p().html() in blank then p().after caret
          else if exist p().next()
            next = p().next()
            if leaf next then next.attr 'id', 'target'
            else next.prepend caret  
          else unless root p() then p().parent().after caret
          else return off
        when 219 # ctrl + [
          if e.ctrlKey and (not (root p()))
            up = p().parent()
            up.after caret
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
          unless exist s()
            m().children().last().attr 'id', 'sel'
          else
            if exist s().prev().prev()
              s().removeAttr('id').prev().prev().attr 'id', 'sel'
            else s().removeAttr 'id'
            return off
        when 34 # pgdown
          if exist s()
            if exist s().next().next()
              s().removeAttr('id').next().next().attr 'id', 'sel'
          else if exist m().children()
            m().children().first().attr 'id', 'sel'
          return off
        when 27 # esc
          if exist m().children() then m().empty()
          return off
        else return on
    point()
    off
  
  cirru.parse = ->
    map = (item, b) ->
      if leaf [item] then item.innerText
      else [$.map item.children, (x) -> map x]
    res = $.map c()[0].children, map
    # console.log 'res:', res
    res

  piece = ->
    all = cirru.parse()
    words = []
    platten = (item) ->
      item.forEach (i) ->
        if Array.isArray i then platten i
        else unless (i is '') or (i in words) then words.push i
    platten all
    words

  put = ->
    {left, top} = p().offset()
    m().offset left: left, top: (top + 20)
    m().empty()
    p()[0].oninput = ->
      x = '.*'
      input = text p()
      exp = new RegExp ('^' + input.split('').join(x))
      aval = piece().filter (item) ->
        (exp.test item) and (item isnt input) and input isnt ''
      m().empty()
      aval[0..10].forEach (item) ->
        m().append "<span>#{item}</span><br>"
        sel = m().children().last().prev()
        sel[0].onclick = ->
          p().html (text sel)
          s().removeAttr 'id'
          focus()
      if exist m().children() then m().children().first().attr 'id', 'sel'

  c().append(caret).after(menu)
  t().attr 'id', 'point'
  focus()
  c()[0].onclick = (e) -> focus()
  c()[0].onscroll = -> put()