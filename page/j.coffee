  
$ ->
  editable = 'contenteditable'
  cursor = "<code id='live' #{editable}='true'></code>"
  ed = $('#editor')
  ed.append cursor
  $('#live').focus()
  ed.click ->
    do -> $('#live').focus()

  click_choose = (elems) ->
    elems.click ->
      old = $('#live').removeAttr(editable).removeAttr('id')
      click_choose old
      elems.attr(editable, 'true').attr('id', 'live')

  $(document).keydown (e) ->
    switch e.keyCode
      when 13
        console.log 'xx'
      when 9
        if $('#live').html().length > 0
          $('#live').after cursor
          old = $('#live').first()
          old.removeAttr(editable).removeAttr('id')
          click_choose old
          $('#live').focus()
    off if e.keyCode in [9, 13]