
leaf = (elem) -> elem[0].tagName is 'CODE'
text = (elem) -> elem.html().replace /<br>/g, ''
add = (x, y) -> x + y

new_scope = (scope) ->
  here = {}
  here.parent = scope
  here.has = {}
  here.search = (key) ->
    if here[key]? then here
    else if here.parent.has[key]? then here.parent.has
    else undefined

see_f = (scope, arr) ->
  key = arr[0]
  res = scope.search key
  if res? then res
  else throw new Error key + 'not found'
set_f = (scope, arr) ->
  [key, value] = arr
  (see_f scope, key)[key] = value
reach_f = (scope, arr) ->
  res = scope
  while arr.length > 0
    head = arr.shift()
    if res[head]? then res = res[head]
    else throw new Error 'wrong path' + arr
  res
echo_f = (scope, arr) ->
  arr = arr.map (item) -> see_f scope, item
  console.log (arr.map String).join(', ')
number_f = (scope, arr)->
  if arr.length is 1 then Number arr[0]
  else arr.map Number

live =  ->
  $('#cirru div').attr 'value', ''
  $('#cirru code').attr 'value', ''  

  origin = {}
  origin.has = {}
  origin.has.bin =
    set: set_f
    '@': reach_f
    echo: echo_f
    number: number_f
  bin = origin.has.bin
  origin.search = (key) ->
    if origin.has.bin[key]? then origin.has.bin
    else if origin.has[key]? then origin.has
    else null

  raw = (elem) ->
    elem.attr 'value', ':f:'
    text elem
  val = (scope, elem) ->
    key = text elem
    pls = scope.search key
    if pls?
      value = pls[key]
      elem.attr 'value', (String value)
      [place, key]
    else
      err = new Error ':not found v:' + key
      elem.attr 'value', err
      throw err
  fun = (scope, elem) ->
    key = text elem
    pls = scope.search key
    if pls?
      value = pls[key]
      if typeof value is 'function'
        elem.attr 'value', ':fun:'
        value
      else
        err = new Error ':not a function:' + key
        elem.attr 'value', err
        throw err
    else
      err = new Error ':not found f:' + key
      elem.attr 'value', err
      throw err
  num = (elem) ->
    n = Number (text elem)
    elem.attr 'value', n
    n

  run = (scope, arr) ->
    console.log run
    key = arr[0]
    pls = scope.search key
    if pls? then pls[key] arr[1..]
    else throw new Error 'not found'

  read = (scope, elem) ->
    if typeof elem is 'string'
      get = scope.has[elem]
      if get? then get else
    list = elem.children()
    list = $.map list, (item) ->
      # item = list[item]
      if item.tagName is 'CODE' then $(item).text()
      else [evaluate scope, $(item)]
    console.log list
    list

  children = $('#cirru').children()
  $.each children, (i) -> read origin, $(children[i])

breath = live