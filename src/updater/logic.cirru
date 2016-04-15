
var
  Immutable $ require :immutable

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

  prependHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 0)
        tree.map $ \ (item index)
          prependHelper item (coord.rest) (is index (coord.first))
        tree.unshift :
      , tree

  packHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 0)
        tree.map $ \ (item index)
          packHelper item (coord.rest) (is index (coord.first))
        Immutable.List $ [] tree
      , tree

  unpackHelper $ \ (tree coord matched)
    cond matched
      cond (> coord.size 1)
        tree.map $ \ (item index)
          unpackHelper item (coord.rest) (is index (coord.first))
        bind (coord.first) $ \ (pos)
          bind (tree.slice 0 pos) $ \ (before)
            bind (tree.slice (+ 1 pos)) $ \ (after)
              bind (or (tree.get pos) (Immutable.List)) $ \ (current)
                before.concat current after
      , tree

  goLeft $ \ (data)
    cond (is data.size 0) data
      bind (data.last) $ \ (last)
        cond (is last 0)
          data.butLast
          data.set (- data.size 1) (- last 1)

  goRight $ \ (tree data)
    cond (is data.size 0) data
      bind (data.butLast) $ \ (containerCoord)
        bind (tree.getIn (containerCoord.toJS)) $ \ (container)
          cond (is (data.last) (- container.size 1))
            data.butLast
            data.set (- data.size 1) (+ 1 (data.last))

  goUp $ \ (data)
    data.butLast

  goDown $ \ (tree data)
    var
      suppose $ data.push 0
      target $ tree.getIn $ data.toJS
    cond (target.has 0) suppose data

  goDownTail $ \ (tree data)
    var
      target $ tree.getIn $ data.toJS
      suppose $ data.push (- target.size 1)
    cond (> target.size 0) suppose data

  prevLineHelper $ \ (tree data)
    var
      target $ tree.getIn (... data (butLast) (toJS))
      targetCoord $ cond (is (typeof target) :string) data (data.butLast)
    cond (is target.size 0) tree
      tree.updateIn (... targetCoord (butLast) (toJS)) $ \ (container)
        ... container
          splice (targetCoord.last) 0 (Immutable.List $ [] :)

  nextLineHelper $ \ (tree data)
    var
      target $ tree.getIn (... data (butLast) (toJS))
      targetCoord $ cond (is (typeof target) :string) data (data.butLast)
    cond (is target.size 0) tree
      tree.updateIn (... targetCoord (butLast) (toJS)) $ \ (container)
        ... container
          splice (+ 1 (targetCoord.last)) 0 (Immutable.List $ [] :)

  focusNextLine $ \ (tree data)
    var
      target $ tree.getIn (... data (butLast) (toJS))
      targetCoord $ cond (is (typeof target) :string) data (data.butLast)
    cond (is targetCoord.size 0) data
      ... targetCoord
        update (- targetCoord.size 1) $ \ (index) (+ 1 index)
        push 0

  focusUnpackNode $ \ (data)
    cond (< data.size 2) data
      bind (data.butLast) $ \ (base)
        base.update (- base.size 1) $ \ (lastItem)
          + lastItem (data.last)

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
      cond (> data.size 0)
        removeHelper tree data true
        , tree
    set :focus $ goLeft data

= exports.beforeToken $ \ (model data)
  cond (is data.size 0) model
    ... model
      update :tree $ \ (tree)
        beforeHelper tree data true

= exports.afterToken $ \ (model data)
  var
    tree $ model.get :tree
  cond (is data.size 0) model
    ... model
      update :tree $ \ (tree)
        afterHelper tree data true
      set :focus
        cond (is data.size 0)
          data.push 0
          data.set (- data.size 1) $ + 1 (data.last)

= exports.prependToken $ \ (model data)
  ... model
    update :tree $ \ (tree)
      prependHelper tree data true
    set :focus $ data.push 0

= exports.prevLine $ \ (model data)
  ... model
    update :tree $ \ (tree)
      prevLineHelper tree data
    set :focus $ ... data (butLast) (push 0)

= exports.nextLine $ \ (model data)
  ... model
    update :tree $ \ (tree)
      nextLineHelper tree data
    set :focus $ focusNextLine (model.get :tree) data

= exports.createLine $ \ (model data)
  ... model
    update :tree $ \ (tree)
      tree.insert data $ Immutable.fromJS ([])
    set :focus $ Immutable.fromJS $ []
      cond (Immutable.is (model.get :tree) (Immutable.List)) 0 data

= exports.packNode $ \ (model data)
  ... model
    update :tree $ \ (tree)
      packHelper tree data true
    set :focus $ data.push 0

= exports.unpackExpr $ \ (model data)
  ... model
    update :tree $ \ (tree)
      unpackHelper tree data true
    set :focus $ data.butLast

= exports.unpackNode $ \ (model data)
  ... model
    update :tree $ \ (tree)
      unpackHelper tree (data.butLast) true
    set :focus $ focusUnpackNode data

= exports.focusTo $ \ (model data)
  ... model
    set :focus data

= exports.goLeft $ \ (model data)
  ... model
    set :focus $ goLeft data

= exports.goRight $ \ (model data)
  var
    tree $ model.get :tree
  ... model
    set :focus $ goRight tree data

= exports.goUp $ \ (model data)
  ... model
    set :focus $ goUp data

= exports.goDown $ \ (model data)
  var
    tree $ model.get :tree
  ... model
    set :focus $ goDown tree data

= exports.goDownTail $ \ (model data)
  var
    tree $ model.get :tree
  ... model
    set :focus $ goDownTail tree data

= exports.duplicate $ \ (model data)
  ... model
    update :tree $ \ (tree)
      ... tree
        updateIn
          ... data (butLast) (toJS)
          \ (expr)
            expr.insert
              data.last
              tree.getIn (data.toJS)
    update :focus $ \ (focus)
      ... focus (butLast)
        push $ + (focus.last) 1
