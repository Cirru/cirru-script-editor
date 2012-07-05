  
$ ->
  editable = 'contenteditable'
  cursor = "<div class='point' #{editable}='true'></div>"
  ed = $('#editor')
  ed.append cursor
  $('.point').focus()
  ed.click ->
    do -> $('.point').focus()

  pop_point = (elems) ->
    elems.removeAttr(editable).removeAttr('class')
    elems
  set_point = (elems) ->
    elems.attr(editable, 'true').attr('class', 'point').focus()
    elems

  click_choose = (elems) ->
    elems[0].onclick = ->
      old = pop_point $('.point')
      click_choose old
      set_point elems
      off

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no
  $(document).keydown (e) ->
    console.log e.keyCode
    if in_sight
      switch e.keyCode
        when 13
          console.log 'xx'
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
            click_choose old
            $('.point').focus()
        when 46
          if $('.point').next().length > 0
            next = $('.point').next()
            old = pop_point $('.point')
            old[0].outerHTML = ''
            set_point next
          else if $('.point').prev().length > 0
            prev = $('.point').prev()
            old = pop_point $('.point')
            old[0].outerHTML = ''
            set_point prev
        when 38 # up
          if $('.point').html().length > 0
            old = pop_point $('.point')
            click_choose old
            old.before cursor
            $('.point').focus()
          else if $('.point').prev().length > 0
            set_point $('.point').prev()
            $('.point')[1].outerHTML = ''
            $('.point').focus()
        when 40 # down
          if $('.point').html().length > 0
            old = pop_point $('.point')
            click_choose old
            old.after cursor
            $('.point').focus()
          else if $('.point').next().length > 0
            set_point $('.point').next()
            $('.point')[0].outerHTML = ''
            $('.point').focus()
        else return on
      off