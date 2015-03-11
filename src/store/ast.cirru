
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher
= manipulations $ require :../util/manipulations
= focusStore    $ require :./focus

= store $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

= astStore $ new EventEmitter

= astStore.dispatchToken $ dispatcher.register $ \ (action)

  switch action.type
    :update-token
      = store $ manipulations.updateToken store action.coord action.text
      astStore.onchange
    :remove-node
      dispatcher.waitFor $ array focusStore.dispatchToken
      = store $ manipulations.removeNode store action.coord
      astStore.onchange
    :before-token
      = store $ manipulations.beforeToken store action.coord
      astStore.onchange
    :after-token
      = store $ manipulations.afterToken store action.coord
      astStore.onchange
    :prepend-token
      = store $ manipulations.prependToken store action.coord
      astStore.onchange
    :pack-node
      = store $ manipulations.packNode store action.coord
      astStore.onchange
    :unpack-expr
      = store $ manipulations.unpackExpr store action.coord
      astStore.onchange
    :drop-to
      = store $ manipulations.dropTo store (focusStore.get) action.coord
      astStore.onchange

_.assign astStore $ object
  :onchange $ \ ()
    localStorage.setItem :cirru-ast $ JSON.stringify store
    @emit :change

  :get $ \ () store

= module.exports astStore
