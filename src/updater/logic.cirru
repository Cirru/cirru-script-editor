
var
  bind $ \ (v k) (k v)

  updaterHelper $ \ (tree coord text matched)
    cond matched
      cond (> coord.size 0)
        tree.map $ \ (item index)
          updaterHelper item (coord.rest) text (is index (coord.first))
        , text
      , tree

  removeHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 1)
        tree.map $ \ (item index)
          removeHelper item (coord.rest) (is (coord.first) index)
        bind (tree.slice 0 (coord.first)) $ \ (before)
          before.concat $ tree.slice (+ 1 (coord.first))
      , tree

  beforeHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 1)
        tree.map $ \ (item index)
          beforeHelper item (coord.rest) (is index (coord.first))
        bind (tree.slice 0 (coord.first)) $ \ (before)
          ... before
            push :
            concat $ tree.slice (coord.first)
      , tree

  afterHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 1)
        tree.map $ \ (item index)
          afterHelper item (coord.rest) (is index (coord.first))
        bind (+ 1 (coord.first)) $ \ (pos)
          bind (tree.slice 0 pos) $ \ (before)
            ... before
              push :
              concat $ tree.slice pos
      , tree

= exports.updateToken $ \ (model data)
  var
    coord $ data.get :coord
    text $ data.get :text
  ... model
    update :tree $ \ (tree)
      updaterHelper tree coord text true

= exports.removeNode $ \ (model data)
  ... model
    update :tree $ \ (tree)
      removeHelper tree data true

= exports.beforeToken $ \ (model data)
  ... model
    update :tree $ \ (tree)
      beforeHelper tree data true

= exports.afterToken $ \ (model data)
  ... model
    update :tree $ \ (tree)
      afterHelper tree data true

= exports.prependToken $ \ (model data)

= exports.packNode $ \ (model data)

= exports.unpackExpr $ \ (model data)

= exports.goLeft $ \ (model data)

= exports.goRight $ \ (model data)

= exports.goUp $ \ (model data)

= exports.goDown $ \ (model data)
