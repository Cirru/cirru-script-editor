editable = 'contenteditable'
caret = "<code id='target' #{editable}='true'/>"
block = "<div>#{caret}</div>"
menu = '<footer id="menu"></footer>'
blank = ['', '<br>']
paste = ''
  
cirru = ->
  unless $? then alert 'Where s my jQuery!?'

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

  center = (elem) ->
    h = c().innerHeight()
    base = c().offset().top
    aim = elem.offset().top
    scrollTop = c().scrollTop()
    # console.log aim, base, scrollTop, h
    c().animate scrollTop: (aim - base + scrollTop - h / 2), 100

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
    if (text p()) is '' then p().html ''
    center p()
    put()

  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    # $('div').addClass 'inline'
    # $('div:has(div)').removeClass 'inline'
    p().focus()
    localStorage.cirru = c().html()

  in_sight = yes
  c().bind 'focus', -> in_sight = yes
  c().bind 'blur', -> in_sight = no

  c().keydown (e) ->
    # console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13 # key enter
          if e.ctrlKey and not (root p())
            if e.shiftKey then p().parent().before block
            else p().parent().after block
          else if exist s()
            p().html (text s())
            s().removeAttr 'id'
            focus()
            return off
          else
            p().after block
            next = p().next()
            next[0].onclick = (e) ->
              next.append caret
        when 9 # key tab
          if e.shiftKey then p().before caret
          else p().after caret
        when 32 # key space
          if exist s() then p().html (text s())
          if e.shiftKey then p().before caret
          else p().after caret
          do breath if breath?
        when 8 # key backpace
          it = if e.shiftKey then p().next() else p().prev()
          if (text p()).length is 0
            if exist it
              if leaf it then it.attr 'id', 'target'
              else if e.shiftKey then it.prepend caret else it.append caret
            else unless root p()
              if e.shiftKey then p().parent().after caret
              else p().parent().before caret
            else return on
          else return on
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
    e.preventDefault()
    e.stopPropagation()
    off
  
  cirru.parse = (elem) ->
    map = (item, b) ->
      if leaf [item] then item.innerText
      else [$.map item.children, (x) -> map x]
    res = $.map elem[0].children, map
    # console.log 'res:', res
    res

  piece = ->
    all = cirru.parse c()
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
      test = (item) ->
        len = input.length
        item[...len] is input[...len]
      aval = piece().filter (item) ->
        (test item) and (input isnt '') and (item isnt input)
      m().empty()
      aval[0..10].forEach (item) ->
        m().append "<span>#{item}</span><br>"
        sel = m().children().last().prev()
        # console.log sel
        # sel[0].onclick = ->
        #   p().html (text sel)
        #   s().removeAttr 'id'
        #   focus()
      if exist m().children() then m().children().first().attr 'id', 'sel'

  if localStorage.cirru?
    c().html(localStorage.cirru).after menu
    for item in $('#cirru div')
      do ->
        elem = $ item
        elem[0].onclick = (e) ->
          elem.append caret
          point()
          e.stopPropagation()
          return off
    for item in $('#cirru code')
      do ->
        elem = $ item
        # console.log elem
        elem[0].onclick = (e) -> if elem isnt p()
          elem.attr 'id', 'target'
          point off
          e.stopPropagation()
          return off
  else unless exist p() then c().append(caret).after menu
  t().attr 'id', 'point'
  focus()
  c()[0].onclick = (e) -> focus()
  c()[0].onscroll = -> put()
  c().bind 'input', -> localStorage.cirru = c().html()