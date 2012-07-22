
live =  ->
  origin = {}
  origin.has =
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

  new_scope = (scope) ->
    child = {}
    child.parent = scope
    child.has = {}

  run = (arr) ->
    

  evaluate = (elem) ->
    list = elem.children()
    list = $.map list, (item) ->
      # item = list[item]
      if item.tagName is 'CODE' then $(item).text()
      else [evaluate $(item)]
    run list

  children = $('#cirru').children()
  $.each children, (i) ->
    list = evaluate $(children[i])
    console.log list

breath = live