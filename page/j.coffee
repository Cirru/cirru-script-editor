  
$ ->
  editable = 'contenteditable'
  cursor = "<code id='target' #{editable}='true'/>"
  blank = ['', '<br>']
  paste = ''

  p = -> $ '#point'
  t = -> $ '#target'

  empty = (elem) -> elem.html() in blank
  branch = (elem) ->
    unless elem.parent().attr('id') is 'editor' then yes
    else no
  exist = (elem) -> elem.length > 0
  leaf = (elem) -> elem[0].tagName is 'CODE'

  target = (elem) ->
    elem.attr('id', 'point').attr(editable, 'true')

  point = (refocus = yes) ->
    old = p().removeAttr('id').removeAttr editable
    if exist old
      old[0].onclick = (e) ->
        old.attr('id', 'target').attr(editable, 'true')
        @onclick = {}
        point off
        e.preventDefault()
        off
      while (empty old) and (branch old)
        up = old.parent()
        old.remove()
        old = up
    target t()
    if refocus then focus()

  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    $('div').addClass 'inline'
    $('div:has(div)').removeClass 'inline'
    p().focus()

  $('#editor').append cursor
  t().attr 'id', 'point'
  focus()
  $('#editor').click ->
    console.log 'called'
    # focus()

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no

  $('#editor').keydown (e) ->
    console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13 then p().after "<div>#{cursor}</div>"
        when 9 then p().after cursor
        when 46 # key delete
          if exist p().prev()
            it = p().prev()
            if leaf it then it.attr 'id', 'target'
            else it.append cursor
          else if exist p().next()
            it = p().next()
            if leaf it then it.attr 'id', 'target'
            else it.prepend cursor
          else if branch p()
            p().parent().after(cursor).remove()
          else unless p().html() in blank then p().after cursor
          else return on
          p().remove()
        when 38 # up
          unless $('.point').html() in empty
            old = pop_point $('.point')
            old.before cursor
          else if $('.point').prev().length > 0
            prev = $('.point').prev()
            if prev[0].tagName is 'DIV'
              set_point $('.point').prev()
            else if prev[0].tagName is 'SECTION'
              prev.append cursor
            $('.point')[1].outerHTML = ''
          else if $('.point').parent().attr('id') isnt 'editor'
            $('.point').parent().before(cursor)
            old = $('.point').last()
            up = old.parent()
            old.remove()
            if up.html() in empty then up.remove()
          focus()
        when 40 # down
          unless $('.point').html() in empty
            old = pop_point $('.point')
            old.after cursor
          else if $('.point').next().length > 0
            next = $('.point').next()
            if next[0].tagName is 'DIV'
              set_point $('.point').next()
            else if next[0].tagName is 'SECTION'
              next.prepend cursor
            $('.point').first().remove()
          else if $('.point').parent().attr('id') isnt 'editor'
            $('.point').parent().after(cursor)
            old = $('.point').first()
            up = old.parent()
            old.remove()
            if up.html() in empty then up.remove()
          focus()
        when 89 # ctrl + y
          up = $('.point').parent()
          if e.ctrlKey and up[0].tagName is 'SECTION'
            up.after cursor
            elems = pop_point $('.point').first()
            while elems.text() in empty
              unless elems.parent().has $('.point')
                up = elems.parent()
                elems.remove()
                elems = up
              else break
            paste = up[0].outerHTML or ''
            up.remove()
            focus()
          else return on
        when 85 # ctrl + u
          if e.ctrlKey and paste.length > 0
            $('.point').before paste
          else return on
        when 33 # pgup
          old = $('.point')
          up = old.parent()
          if up.attr('id') isnt 'editor'
            up.before cursor
            pop_point old
            if old.html() in empty
              old.remove()
              if up.children().length is 0
                up.remove()
          focus()
        when 34 # pgdown
          old = $('.point')
          up = old.parent()
          if up.attr('id') isnt 'editor'
            up.after cursor
            pop_point old
            if old.html() in empty
              old.remove()
              if up.children().length is 0
                up.remove()
          focus()
        else return on
      point()
    off
  window.parse = ->
    map = (item) ->
      if item.tagName is 'DIV'
        item.innerText
      else if item.tagName is 'SECTION'
        console.log item.children
        res = $.map item.children, (x) ->
          map x
        [res]
    res = $.map $('#editor')[0].children, map
    console.log 'res:', res