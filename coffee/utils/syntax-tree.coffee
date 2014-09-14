
isArr = (x) -> Array.isArray x
isStr = (x) -> (typeof x) is 'string'

id =
  counter: 0
  make: ->
    ret = @counter.toString(16)
    @counter += 1
    ret

exports.label = label = (ast) ->
  if isStr ast
    id: id.make()
    type: 'token'
    value: ast
  else if isArr ast
    id: id.make()
    type: 'sequence'
    value: ast.map label

exports.leach = leach = (tree) ->
  if tree.type is 'token'
    tree.value
  else if tree.type is 'sequence'
    tree.value.map leach

exports.updateToken = updateToken = (tree, token) ->
  if tree.type is 'token'
    if tree.id is token.id
      if tree.value isnt token.value
        tree.value = token.value
        console.log 'replace', tree.value
  else if tree.type is 'sequence'
    tree.value.map (item) ->
      updateToken item, token
  tree