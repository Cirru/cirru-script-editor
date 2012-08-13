
l = '\u00d1'
r = '\u00d2'
s = '\u00d3'

indent = (item) ->
  spaces = item.match /^\s*/
  spaces[0].length

group = (lines) ->
  res = []
  for item in lines
    n = indent item[0]
    if n is 0 then res.push item
    else if n >= 2
      end = res.length - 1
      res[end].push [item[0][2..]]
    else throw new Error "odd indent::", item
  res

folding = (step) ->
  res = []
  for item in step
    if typeof item is 'string' then res.push item
    else 
      n = indent item[0]
      if n is 0 then res.push item
      else if n >= 2
        end = res.length - 1
        res[end].push [item[0][2..]]
      else throw new Error 'odd indent::', item
  res = res.map (x) ->
    if typeof x is 'string' then x
    else folding x
  res

fill = (x) -> x.length > 0

mask = (str) ->
  str = str.replace /\\\(/g, 'Ñ'
  str = str.replace /\\\)/g, 'Ò'
  str = str.replace /\\\s/g, 'Ø'
  str

unmask = (str) ->
  show str
  str = str.replace /Ñ/g, '('
  str = str.replace /Ò/g, ')'
  str = str.replace /Ø/g, ' '
  str

divide = (str) ->
  if str[..2] is '// ' then ['//', str[3..].trim()]
  else if str[..1] is '| ' then [str[2..].trim()]
  else 
    str = mask str
    put str
    p = str.indexOf '('
    if p < 0 then str.split(' ').filter(fill).map(unmask)
    else
      sub = str[p+1..]
      q = 0
      c = 1
      for item, index in sub
        q += 1
        if item is '(' then c += 1
        else if item is ')'
          c -= 1
          show 'show c:', c
          if c is 0 then break
      if c > 0 then throw new Error 'pair not close'
      s1 = str[...p]
      s1 = unmask s1
      s2 = str[p+1...p+q]
      s3 = str[p+q+1..]
      res = []
      res.push s for s in (s1.split ' ').filter(fill)
      res.push (divide s2)
      res.push s for s in (divide s3)
      res

walk = (arr) -> # to divide string
  res = []
  for item in arr
    if typeof item is 'string'
      res.push x for x in (divide item)
    else res.push (walk item)
  res

exports.to_array = (source) ->
  source = String source
  lines = source.split('\n').filter (item) ->
    cond1 = item.trimLeft()[0..1] isnt '--'
    cond2 = item.trim().length > 0
    (cond1 and cond2)
  lines = lines.map (item) -> [item.trimRight()]
  lines = (group lines).map folding
  lines = lines.map walk
  lines