
exports.fuzzy = (xs, ys) ->
  if xs[0] isnt ys[0] then return no
  for x in xs.split('')
    if ys[0] is x then ys = ys[1..]
  return ys.length is 0