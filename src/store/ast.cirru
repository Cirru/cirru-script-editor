
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher

= store $ array
  array :this :is :a :demo
  array :this :is :another
  array :try
    array :another
      array :nested

= astStore $ new EventEmitter

= astStore.dispatchToken $ dispatcher.register $ \ (action)

  switch action.type
    :update-token (console.log :not-implemented)
    else (console.log :else-not-implemented)

_.assign astStore $ object
  :onchange $ \ ()
    @emit :change

  :get $ \ ()
    store

= module.export astStore
