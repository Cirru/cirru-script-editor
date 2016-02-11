
var
  _ $ require :lodash
  detect $ require :../util/detect

  bind $ \ (v k) (k v)

  updateHelper $ \ (ast coord text matched)
    cond matched
      cond (> coord.length 0)
        ast.map $ \ (item index)
          updateHelper item (coord.slice 1) text (is (. coord 0) index)
        , text
      , ast

  afterHelper $ \ (ast coord matched)
    cond matched
      cond (> coord.length 1)
        ast.map $ \ (item index)
          afterHelper item (coord.slice 1) (is (. coord 0) index)
        bind (+ 1 $ . coord 0) $ \ (pos)
          bind (ast.slice 0 pos) $ \ (before)
            before.concat (array :) (ast.slice pos)
      , ast

  beforeHelper $ \ (ast coord matched insertion)
    cond matched
      cond (> coord.length 1)
        ast.map $ \ (item index)
          beforeHelper item (coord.slice 1) (is (. coord 0) index) insertion
        bind (. coord 0) $ \ (pos)
          bind (ast.slice 0 pos) $ \ (before)
            before.concat (array insertion) (ast.slice pos)
      , ast

  removeHelper $ \ (ast coord matched)
    cond matched
      cond (> coord.length 1)
        ast.map $ \ (item index)
          removeHelper item (coord.slice 1) (is (. coord 0) index)
        bind (. coord 0) $ \ (pos)
          bind (ast.slice 0 pos) $ \ (before)
            before.concat $ ast.slice (+ pos 1)
      , ast

  prependHelper $ \ (ast coord matched)
    cond matched
      cond (> coord.length 0)
        ast.map $ \ (item index)
          prependHelper item (coord.slice 1) (is (. coord 0) index)
        bind (array :) $ \ (before)
          before.concat ast
      , ast

  appendHelper $ \ (ast coord matched insertion)
    cond matched
      cond (> coord.length 0)
        ast.map $ \ (item index)
          appendHelper item (coord.slice 1) (is (. coord 0) index) insertion
        ast.concat $ array insertion
      , ast

  packHelper $ \ (ast coord matched)
    cond matched
      cond (> coord.length 0)
        ast.map $ \ (item index)
          packHelper item (coord.slice 1) (is (. coord 0) index)
        array ast
      , ast

  unpackHelper $ \ (ast coord matched)
    cond matched
      cond (> coord.length 1)
        ast.map $ \ (item index)
          unpackHelper item (coord.slice 1) (is (. coord 0) index)
        bind (. coord 0) $ \ (pos)
          bind (ast.slice 0 pos) $ \ (before)
            bind (ast.slice (+ pos 1)) $ \ (after)
              bind (or (. ast pos) (array)) $ \ (current)
                before.concat current after
      , ast

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

var getHelper $ \ (ast coord)
  if (is coord.length 0)
    do $ return ast
  getHelper (. ast (. coord 0)) (coord.slice 1)

= exports.dropTo $ \ (ast focus coord)
  if (detect.contains coord focus)
    do $ return ast

  var
    node $ getHelper ast focus
    target $ getHelper ast coord

  = ast $ removeHelper ast focus true
  cond (_.isArray target)
    appendHelper ast coord true node
    beforeHelper ast coord true node
