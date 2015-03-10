
= _ $ require :lodash
= detect $ require :../util/detect

= updateHelper $ \ (ast coord text matched)
  if matched
    do $ if (> coord.length 0)
      do $ ast.map $ \ (item index)
        updateHelper item (coord.slice 1) text (is (. coord 0) index)
      do text
    do ast

= afterHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 1)
      do $ ast.map $ \ (item index)
        afterHelper item (coord.slice 1) (is (. coord 0) index)
      do
        = pos $ + 1 $ . coord 0
        = before $ ast.slice 0 pos
        before.concat (array :) (ast.slice pos)
    do ast

= beforeHelper $ \ (ast coord matched insertion)
  if matched
    do $ if (> coord.length 1)
      do $ ast.map $ \ (item index)
        beforeHelper item (coord.slice 1) (is (. coord 0) index) insertion
      do
        = pos $ . coord 0
        = before $ ast.slice 0 pos
        before.concat (array insertion) (ast.slice pos)
    do ast

= removeHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 1)
      do $ ast.map $ \ (item index)
        removeHelper item (coord.slice 1) (is (. coord 0) index)
      do
        = pos $ . coord 0
        = before $ ast.slice 0 pos
        before.concat $ ast.slice (+ pos 1)
    do ast

= prependHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 0)
      do $ ast.map $ \ (item index)
        prependHelper item (coord.slice 1) (is (. coord 0) index)
      do
        = before $ array :
        before.concat ast
    do ast

= appendHelper $ \ (ast coord matched insertion)
  if matched
    do $ if (> coord.length 0)
      do $ ast.map $ \ (item index)
        appendHelper item (coord.slice 1) (is (. coord 0) index) insertion
      do
        ast.concat $ array insertion
    do ast

= packHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 0)
      do $ ast.map $ \ (item index)
        packHelper item (coord.slice 1) (is (. coord 0) index)
      do $ array ast
    do ast

= unpackHelper $ \ (ast coord matched)
  if matched
    do $ if (> coord.length 1)
      do $ ast.map $ \ (item index)
        unpackHelper item (coord.slice 1) (is (. coord 0) index)
      do
        = pos $ . coord 0
        = before $ ast.slice 0 pos
        = after $ ast.slice (+ pos 1)
        = current $ or (. ast pos) (array)
        console.log before current after
        before.concat current after
    do ast

= exports.updateToken $ \ (ast coord text)
  updateHelper ast coord text true

= exports.removeNode $ \ (ast coord)
  removeHelper ast coord true

= exports.beforeToken $ \ (ast coord)
  beforeHelper ast coord true :

= exports.afterToken $ \ (ast coord)
  afterHelper ast coord true

= exports.prependToken $ \ (ast coord)
  prependHelper ast coord true

= exports.packNode $ \ (ast coord)
  packHelper ast coord true

= exports.unpackExpr $ \ (ast coord)
  unpackHelper ast coord true

= exports.dropTo $ \ (ast focus coord node inside)
  if (detect.contains coord focus)
    do $ return ast

  = ast $ removeHelper ast focus
  if inside
    do $ return $ appendHelper ast coord true node
    do $ return $ beforeHelper ast coord true node
