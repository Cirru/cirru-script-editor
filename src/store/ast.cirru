
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher
= manipulations $ require :../util/manipulations
= caret         $ require :../util/caret
= history       $ require :../util/history

= store $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

= store $ array :demo

= focus $ array
history.init $ object
  :store store
  :focus focus

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
      = store $ manipulations.afterToken store action.coord
      = focus $ caret.forward store action.coord
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
    localStorage.setItem :cirru-ast $ JSON.stringify (or store $ array)
    @emit :change

  :get $ \ () store

  :getFocus $ \ () focus

= module.exports astStore
