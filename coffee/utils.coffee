
exports.push = (x, xs) ->
  new_list = [x]
  for y in xs
    new_list.push y unless y in new_list
  new_list

exports.delay = (t, f) ->
  setTimeout f, t

exports.parseElement = (represent) ->
  [_, base, query] = represent.match /^(\w+)(\s.*)$/
  {base, query}