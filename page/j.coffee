  
cirru = ->
  editable = 'contenteditable'
  caret = "<code id='target' #{editable}='true'/>"
  menu = '<footer id="menu"></footer>'
  blank = ['', '<br>']
  paste = ''

  words = []
  aval = []

  window.p = -> $ '#point'
  window.t = -> $ '#target'
  window.m = -> $ '#menu'
  window.s = -> $ '#sel'

  empty = (elem) -> elem.html() in blank
  root = (elem) -> elem.parent().attr('id') is 'editor'
  exist = (elem) -> elem.length > 0
  leaf = (elem) -> elem[0].tagName is 'CODE'

  point = (refocus = yes) ->
    aval = []
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
    t().attr('id', 'point').attr(editable, 'true')
    if refocus then focus()
    put()

  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    $('div').addClass 'inline'
    $('div:has(div)').removeClass 'inline'
    p().focus()
    piece()

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no

  $('#editor').keydown (e) ->
    # console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13
          p().after "<div>#{caret}</div>"
          next = p().next()
          next[0].onclick = (e) ->
            next.append caret
            point()
            e.stopPropagation()
        when 9 then p().after caret
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
          if exist aval
            if exist s()
              if exist s().prev()
                s().removeAttr('id').prev().attr 'id', 'sel'
              else
                s().removeAttr('id')
                m().empty()
                aval = []
            return off
          else
            unless p().html() in blank then p().before caret
            else if exist p().prev()
              prev = p().prev()
              if leaf prev then prev.attr 'id', 'target'
              else prev.append caret  
            else unless root p() then p().parent().before caret
            else return off
        when 40 # down
          if exist aval
            if exist s()
              if exist s().next()
                s().removeAttr('id').next().attr 'id', 'sel'
            else m().children().first().attr 'id', 'sel'
            return off
          else
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
          unless root p() then p().parent().before caret
          else return on
        when 34 # pgdown
          unless root p() then p().parent().after caret
          else return on
        else return on
    point()
    off
  
  cirru.parse = ->
    map = (item, b) ->
      if leaf [item] then item.innerText
      else [$.map item.children, (x) -> map x]
    res = $.map $('#editor')[0].children, map
    # console.log 'res:', res
    res

  piece = ->
    all = cirru.parse()
    words = []
    platten = (item) ->
      item.forEach (i) ->
        if Array.isArray i then platten i
        else unless i is '' or i in words then words.push i
    platten all

  put = ->
    {left, top} = p().offset()
    m().offset left: left, top: (top + 20)
    m().empty()
    p()[0].oninput = ->
      x = '.*'
      input = p().html().replace(/<br>/g, '')
      exp = new RegExp ('^' + input.split('').join(x))
      aval = words.filter (item) -> exp.test item
      m().empty()
      unless input is ''
        aval.forEach (item) ->
          m().append "<span>#{item}<br></span>"

  $('#editor').append(caret).after(menu)
  t().attr 'id', 'point'
  focus()
  $('#editor')[0].onclick = (e) -> focus()

$ -> cirru()