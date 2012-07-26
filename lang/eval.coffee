
live =  ->
  origin = {}
  origin.children = {}
  origin.children.bin =
    set: (key) -> (value) -> key = value
    '@': (scope) -> (arr) ->
      dest = scope
      for item in arr
        dest =
          if item is '..' then dest.parent
          else if item is '/' then origin
          else dest[item]
    echo: (arr) -> console.log (arr.map String).join(', ')
    number: (arr) ->
      if arr.length is 1 then Number arr[0]
      else arr.map Number
    '+': (arr) -> (arr.map Number).reduce (x, y) -> x + y
  origin.search = (key) ->
    if origin.children.bin[key]? then origin.children.bin
    else if origin.children[key]? then origin.children
    else undefined

  new_scope = (scope) ->
    here = {}
    here.parent = scope
    here.children = {}
    here.search = (key) ->
      if origin.children.bin[key]? then origin.children.bin
      else if here[key]? then here
      else if here.parent.children[key]? then here.parent.children
      else undefined

  run = (scope, arr) ->
    key = arr[0]
    pls = scope.search key
    if pls? then pls[key] arr[1..]
    else throw new Error 'not found'

  evaluate = (scope, elem) ->
    list = elem.children()
    list = $.map list, (item) ->
      # item = list[item]
      if item.tagName is 'CODE' then $(item).text()
      else [evaluate scope, $(item)]
    run origin, list

  children = $('#cirru').children()
  $.each children, (i) ->
    list = evaluate origin, $(children[i])
    console.log list

breath = live