
var
  plainString $ \ (token)
    cond
      ? $ token.match /^\w[\w\d-_\.]*$
      , token
      JSON.stringify token

  plainExpr $ \ (tree)
    ... tree
      map $ \ (node)
        cond (is (typeof node) :string)
          plainString node
          +  ":(" (plainExpr node) ":)"
      join ": "

= exports.plain $ \ (tree)
  plainExpr tree