
leaf = (elem) -> elem[0].tagName is 'CODE'
text = (elem) -> elem.html().replace /<br>/g, ''
exist = (elem) -> elem.length > 0

anchor = {}

breath = ->
  # anchor = p().prev()
  # unless exist anchor then return off
  # p().remove()
  $('#cirru div').attr 'value', ''
  $('#cirru code').attr 'value', ''  

  scope = {}

  raw = (elem) ->
    elem.attr 'value', ':raw:'
    text elem
  one = (elem, f) ->
    try f elem
    catch e
      elem.attr 'value', e
  num = (elem) -> Number (raw elem)
  nux = (elem) -> num elem.next()
  nes = (elem) -> if leaf elem then num elem else one elem, read
  get = (elem) -> scope[raw elem.next()]
  set = (elem) ->
    elem = elem.next()
    key = raw elem
    value = nes elem.next()
    scope[key] = value
  cal = (elem, f) ->
    res = nes elem.next()
    elem = elem.next()
    while exist elem.next()
      elem = elem.next()
      res = f res, (nes elem)
    res
  add = (elem) -> cal elem, (x, y) -> x + y
  sub = (elem) -> cal elem, (x, y) -> x - y
  mul = (elem) -> cal elem, (x, y) -> x * y
  div = (elem) -> cal elem, (x, y) -> x / y

  read = (elem) ->
    head = elem.children().first()
    head.attr 'value', ':fun:'
    ret = switch text head
      when 'get' then get head
      when 'set' then set head
      when 'add' then add head
      when 'sub' then sub head
      when 'num' then nux head
      when 'mul' then mul head
      when 'div' then div head
      else new Error '$not defined$'
    head.parent().attr 'value', ret
    ret

  each = $('#cirru').children()
  $.each each, (i) -> one $(each[i]), read