
isStr = (str) -> typeof str is 'string'
isArr = (arr) -> Array.isArray arr

c = (x) ->
  if isStr x then x else
    try
      head = x[0]
      if s[head]?
        if head in ['try']
          "#{s[head] x[1..]}"
        else "(#{s[head] x[1..]})"
      else throw new Error "exp [#{arr.join ' '}] missing"
    catch err
      show "err running [#{x.join ' '}]"

s =
  '+': (a) -> a.map(c).join ' + '
  '-': (a) -> a.map(c).join ' - '
  '*': (a) -> a.map(c).join ' * '
  '/': (a) -> a.map(c).join ' / '
  '=': (a) ->
    if isStr a[0] then "#{a[0]} = #{c a[1]}"
    else if isArr a[0]
      ret = ''
      for item, index in a[0]
        ret += "#{item} = #{c a[1][index]};"
      ret
  '.': (a) ->
    ret = a[0]
    show a
    for item in a[1..]
      ret +=
        if isStr item then ".#{item}"
        else if isArr item then "(#{item.map(c).join ','})"
    ret
  'list': (a) -> "[#{a.map(c).join ','}]"
  '#': (a) -> s.list a
  'json': (a) ->
    f = (arr) -> "#{s.str arr[..0]} : #{c arr[1]}"
    "{#{a.map(f).join ', '}}"
  '&': (a) -> s.json a
  'str': (a) ->
    g = (s) -> s.replace(/\"/g, '\\"').replace(/\'/g, "\\'")
    f = (x) -> if isStr x then "\"#{g x}\"" else c x
    "String(#{a.map(f).join ' + '})"
  '"': (a) -> s.str a
  '>': (a) -> a.map(c).join ' > '
  '<': (a) -> a.map(c).join ' < '
  '<=': (a) -> a.map(c).join ' <= '
  '>=': (a) -> a.map(c).join ' >= '
  'is': (a) -> a.map(c).join ' === '
  '!=': (a) -> a.map(c).join ' !== '
  '+=': (a) -> "#{c a[0]} += #{c a[1]}"
  '-=': (a) -> "#{c a[0]} -= #{c a[1]}"
  '*=': (a) -> "#{c a[0]} *= #{c a[1]}"
  '/=': (a) -> "#{c a[0]} /= #{c a[1]}"
  '%=': (a) -> "#{c a[0]} %= #{c a[1]}"
  '==': (a) -> s.is a
  'isnt': (a) -> s['!='] a
  '//': (a) -> "/#{a[1]}/#{a[0]}"
  'null': -> 'null'
  'undefined': -> 'undefined'
  'break': -> 'break'
  'continue': -> 'continue'
  'return': (a) -> "return #{a.map(c)}"
  'try': (a) ->
    show 'try: ', a
    a1 = a[0]
    a2 = a[1][0]
    a3 = a[1][1..]
    "try{#{flow a1}}catch(#{a2}){#{flow a3}}"
  # 'if':
  # 'while':
  # 'for':
  # 'each':
  # 'fn':
  # 'do':
  # 'and':
  # 'or':
  # 'not':
  # '&&': syntax.and
  # '||': syntax.or
  # '!!': syntax.not

flow = (tree) ->
  res = ''
  for arr in tree
    try
      res += c arr
      res += ';'
    catch err
      show "error evaling [#{arr.join ' '}]"
      throw err
  show res
  res

exports.to_code = flow