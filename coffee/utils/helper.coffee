
module.exports =
  switch: (name, registry) ->
    registry[name]()

  if: (cond, a, b) ->
    if cond then a() else b?()

  concat: (args...) ->
    list = []
    for arg in args
      list.push arg if arg?
    list.join(' ')