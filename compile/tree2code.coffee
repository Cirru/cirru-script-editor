
isStr = (str) -> typeof str is 'string'
isArr = (arr) -> Array.isArray arr

bare = ['if', 'try', 'while', 'each', 'fn',
  'break', 'continue', 'return', 'switch', 'flow']

c = (x) ->
  if isStr x then x
  else
    try
      head = x[0]
      if s[head]?
        if head in bare then "#{s[head] x[1..]}"
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
    for item in a[1..]
      if isStr item then ret += ".#{item}" else
        b1 = c item[0]
        b2 = "(#{item[1..].map(c).join ','})"
        ret += ".#{b1}#{b2}"
    ret
  'list': (a) -> "[#{a.map(c).join ','}]"
  'json': (a) ->
    f = (arr) -> "#{s.str arr[..0]} : #{c arr[1]}"
    "{#{a.map(f).join ', '}}"
  'str': (a) ->
    g = (s) -> s.replace(/\"/g, '\\"').replace(/\'/g, "\\'")
    f = (x) -> if isStr x then "\"#{g x}\"" else c x
    a.map(f).join ' + '
  '>': (a) -> a.map(c).join ' > '
  '<': (a) -> a.map(c).join ' < '
  '<=': (a) -> a.map(c).join ' <= '
  '>=': (a) -> a.map(c).join ' >= '
  'is': (a) -> a.map(c).join ' === '
  'isnt': (a) -> a.map(c).join ' !== '
  '+=': (a) -> "#{c a[0]} += #{c a[1]}"
  '-=': (a) -> "#{c a[0]} -= #{c a[1]}"
  '*=': (a) -> "#{c a[0]} *= #{c a[1]}"
  '/=': (a) -> "#{c a[0]} /= #{c a[1]}"
  '%=': (a) -> "#{c a[0]} %= #{c a[1]}"
  '//': (a) -> "/#{a[1]}/#{a[0]}"
  'null': -> 'null'
  'undefined': -> 'undefined'
  'break': -> 'break'
  'continue': -> 'continue'
  'return': (a) -> "return #{c a[0]}"
  'flow': (a) -> flow a
  'try': (a) ->
    "try{#{c a[0]}}catch(#{a[1][0]}){#{c a[2]}}"
  'if': (a) ->
    ret = "if(#{c a[0]}){#{c a[1]}}"
    if a[2]? then ret += "else{#{c a[2]}}"
    ret
  'while': (a) -> "while(#{c a[0]}){#{c a[1]}}"
  'each': (a) ->
    "for(#{c a[1]} in #{c a[0]}){
      #{a[2]} = #{a[0]}[#{a[1]}];
      #{c a[3]}}"
  'fn': (a) ->
    "function _f(#{a[0].join ','}){#{c a[1]}}"
  'do': (a) -> "#{a[0]}(#{a[1..].map(c).join ','})"
  'and': (a) -> a.map(c).join ' && '
  'or': (a) -> a.map(c).join ' || '
  'not': (a) -> "! #{c a}"
  '..': (a) -> "#{a[0]}.slice(#{a[1..].join ','})"
  'switch': (a) ->
    b = ''
    for item in a[1...-1]
      b += "case #{c item[0]}: #{c item[1]}; break;"
    b += "default: #{c a[-1..-1][0]}"
    ret = "switch(#{a[0]}){#{b}}"
  'bare': (a) -> a[0]

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