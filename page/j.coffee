  
$ ->
  editable = 'contenteditable'
  cursor = "<div class='point' #{editable}='true'></div>"
  empty = ['', '<br>']

  ed = $('#editor')
  ed.append cursor
  $('.point').focus()
  ed.click ->
    do -> $('.point').focus()
  paste = ''

  click_choose = (elems) ->
    elems[0].onclick = ->
      old = $('.point').removeAttr(editable).removeAttr('class')
      click_choose old
      if old.html().length is 0
        up = old.parent()
        old.remove()
        while up.html() in empty
          old = up
          up = up.parent()
          old.remove()
      set_point elems
      off
  pop_point = (elems) ->
    elems.removeAttr(editable).removeAttr('class')
    click_choose elems
    elems
  set_point = (elems) ->
    elems.attr(editable, 'true').attr('class', 'point').focus()
    elems

  focus = ->
    sel = window.getSelection()
    sel.collapse $('.point')[0], 1
    $('.point').focus()

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no
  $(document).keydown (e) ->
    console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13
          old = pop_point $('.point')
          old.after "<section>#{cursor}</section>"
          focus()
          if old.html() in empty then old.first().remove()
        when 9
          if $('.point').html().length > 0
            if e.shiftKey
              $('.point').before cursor
              old = $('.point').last()
            else
              $('.point').after cursor
              old = $('.point').first()
            pop_point old
            focus()
        when 46 # key delete
          if $('.point').next().length > 0
            next = $('.point').next()
            old = pop_point $('.point')
            old.remove()
            if next[0].tagName is 'DIV'
              set_point next
            else if next[0].tagName is 'SECTION'
              next.prepend cursor
          else if $('.point').prev().length > 0
            prev = $('.point').prev()
            old = pop_point $('.point')
            old.remove()
            if prev[0].tagName is 'DIV'
              set_point prev
            else
              prev.append cursor
          else unless $('.point').text() in empty
            $('.point').text ''
          else
            if $('.point').parent()[0].tagName isnt 'SECTION'
              $('.point').text('')
            else
              $('.point').parent()[0].outerHTML = cursor
          focus()
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
            pop_point $('.point').first()
            paste = up[0].outerHTML
            up.remove()
            focus()
        when 85 # ctrl + u
          if e.ctrlKey and paste.length > 0
            $('.point').before paste
        else return on
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