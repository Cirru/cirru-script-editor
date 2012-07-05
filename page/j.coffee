  
$ ->
  editable = 'contenteditable'
  cursor = "<div class='point' #{editable}='true'></div>"
  ed = $('#editor')
  ed.append cursor
  $('.point').focus()
  ed.click ->
    do -> $('.point').focus()

  click_choose = (elems) ->
    elems[0].onclick = ->
      old = $('.point').removeAttr(editable).removeAttr('class')
      click_choose old
      if old.html().length is 0
        old[0].outerHTML = ''
      set_point elems
      off
  pop_point = (elems) ->
    elems.removeAttr(editable).removeAttr('class')
    click_choose elems
    elems
  set_point = (elems) ->
    elems.attr(editable, 'true').attr('class', 'point').focus()
    elems

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
          $('.point').focus()
          if old.html().length is 0
            old[0].outerHTML = ''
        when 9
          if $('.point').html().length > 0
            if e.shiftKey
              $('.point').before cursor
              old = $('.point').last()
            else
              $('.point').after cursor
              old = $('.point').first()
            console.log $('.point')
            pop_point old
            $('.point').focus()
        when 46
          if $('.point').next().length > 0
            next = $('.point').next()
            old = pop_point $('.point')
            old.remove()
            if next[0].tagName is 'DIV'
              set_point next
            else if next[0].tagName is 'SECTION'
              next.prepend cursor
              $('.point').focus()
          else if $('.point').prev().length > 0
            prev = $('.point').prev()
            old = pop_point $('.point')
            old.remove()
            if prev[0].tagName is 'DIV'
              set_point prev
            else
              prev.append cursor
              $('.point').focus()
        when 38 # up
          if $('.point').html().length > 0
            old = pop_point $('.point')
            old.before cursor
            $('.point').focus()
          else if $('.point').prev().length > 0
            prev = $('.point').prev()
            if prev[0].tagName is 'DIV'
              set_point $('.point').prev()
            else if prev[0].tagName is 'SECTION'
              prev.append cursor
            $('.point')[1].outerHTML = ''
            $('.point').focus()
          else if $('.point').parent().attr('id') isnt 'editor'
            $('.point').parent().before(cursor)
            $('.point').last().remove()
            $('.point').focus()
        when 40 # down
          if $('.point').html().length > 0
            old = pop_point $('.point')
            old.after cursor
            $('.point').focus()
          else if $('.point').next().length > 0
            next = $('.point').next()
            if next[0].tagName is 'DIV'
              set_point $('.point').next()
            else if next[0].tagName is 'SECTION'
              next.prepend cursor
            $('.point')[0].outerHTML = ''
            $('.point').focus()
          else if $('.point').parent().attr('id') isnt 'editor'
            $('.point').parent().after(cursor)
            $('.point').first().remove()
            $('.point').focus()
        else return on
      off