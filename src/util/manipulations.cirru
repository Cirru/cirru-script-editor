
= updateHelper $ \ (ast coord text matched)
  if matched
    do $ if (> coord.length 0)
      do
        = head $ . coord 0
        = body $ coord.slice 1
        ast.map $ \ (item index)
          updateHelper item body text (is head index)
      do text
    do ast

= newHelper $ \ (ast coord insertion matched)
  if matched
    do $ if (> coord.length 1)
      do
        = head $ . coord 0
        = body $ coord.slice 1
        ast.map $ \ (item index)
          newHelper item body insertion (is head index)
      do
        = pos $ + 1 $ . coord 0
        = before $ ast.slice 0 pos
        before.concat (array insertion) (ast.slice pos)
    do ast

= removeHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 1)
      do
        = head $ . coord 0
        = body $ coord.slice 1
        ast.map $ \ (item index)
          removeHelper item body (is head index)
      do
        = pos $ . coord 0
        = before $ ast.slice 0 pos
        before.concat $ ast.slice (+ pos 1)
    do ast

= exports.updateToken $ \ (ast coord text)
  updateHelper ast coord text true

= exports.newToken $ \ (ast coord)
  newHelper ast coord : true

= exports.newExpr $ \ (ast coord)
  newHelper ast coord (array :) true

= exports.removeNode $ \ (ast coord)
  removeHelper ast coord true
