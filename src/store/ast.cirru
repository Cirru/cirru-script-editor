
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher
= manipulations $ require :../util/manipulations

= store $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

= store $ array
  array :this :is :a :demo
  array :this :is :another
  array :try
    array :another
      array :nested

= astStore $ new EventEmitter

= astStore.dispatchToken $ dispatcher.register $ \ (action)

  switch action.type
    :update-token
      = store $ manipulations.updateToken store action.coord action.text
      astStore.onchange
    else (console.log :else-not-implemented)

_.assign astStore $ object
  :onchange $ \ ()
    localStorage.setItem :cirru-ast $ JSON.stringify store
    @emit :change

  :get $ \ () store

= module.exports astStore
