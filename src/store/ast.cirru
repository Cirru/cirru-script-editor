
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher
= manipulations $ require :../util/manipulations
= focusStore    $ require :./focus

= store $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

-- "force set to empty"
= store $ array

= astStore $ new EventEmitter

= astStore.dispatchToken $ dispatcher.register $ \ (action)

  switch action.type
    :update-token
      = store $ manipulations.updateToken store action.coord action.text
      astStore.onchange
    :new-token
      = store $ manipulations.newToken store action.coord
      astStore.onchange
    :new-expr
      = store $ manipulations.newExpr store action.coord
      astStore.onchange
    :remove-node
      dispatcher.waitFor $ array focusStore.dispatchToken
      = store $ manipulations.removeNode store action.coord
      astStore.onchange
    :insert-token
      = store $ manipulations.insertToken store action.coord
      astStore.onchange

_.assign astStore $ object
  :onchange $ \ ()
    localStorage.setItem :cirru-ast $ JSON.stringify store
    @emit :change

  :get $ \ () store

= module.exports astStore
