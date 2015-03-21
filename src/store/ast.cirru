
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher
= manipulations $ require :../util/manipulations
= caret         $ require :../util/caret
= history       $ require :../util/history

= store $ array
= focus $ array

= astStore $ new EventEmitter

= astStore.dispatchToken $ dispatcher.register $ \ (action)

  switch action.type
    :update-token
      = store $ manipulations.updateToken store action.coord action.text
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :remove-node
      if (is action.coord.length 0)
        do return
      = store $ manipulations.removeNode store action.coord
      = focus $ caret.backward store action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :before-token
      = store $ manipulations.beforeToken store action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :after-token
      = needWrap $ is action.coord.length 1
      = store $ manipulations.afterToken store action.coord
      = focus $ caret.forward store action.coord
      if needWrap
        do
          = store $ manipulations.packNode store focus
          = focus $ caret.inside store focus
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :prepend-token
      = store $ manipulations.prependToken store action.coord
      = focus $ caret.inside store action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :pack-node
      = store $ manipulations.packNode store action.coord
      = focus $ caret.inside store action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :unpack-expr
      = store $ manipulations.unpackExpr store action.coord
      = focus action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :drop-to
      = store $ manipulations.dropTo store focus action.coord
      = focus action.coord
      history.add $ object (:store store) (:focus focus)
      astStore.onchange
    :focus-to
      = focus action.coord
      astStore.onchange
    :go-left
      = focus $ caret.left store focus
      astStore.onchange
    :go-right
      = focus $ caret.right store focus
      astStore.onchange
    :go-up
      = focus $ caret.up store focus
      astStore.onchange
    :go-down
      = focus $ caret.down store focus
      astStore.onchange
    :undo
      = piece $ history.undo
      = store piece.store
      = focus piece.focus
      astStore.onchange
    :redo
      = piece $ history.redo
      = store piece.store
      = focus piece.focus
      astStore.onchange

_.assign astStore $ object
  :onchange $ \ ()
    @emit :change

  :get $ \ () store

  :getFocus $ \ () focus

  :init $ \ (initialStore initialFocus)
    = store initialStore
    = focus initialFocus
    history.init $ object
      :store store
      :focus focus

= module.exports astStore
