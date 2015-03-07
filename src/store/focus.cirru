
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher

= store $ array

= focusStore $ new EventEmitter

= focusStore.dispatchToken $ dispatcher.register $ \ (action)
  switch action.type
    :focus
      = store action.coord
      focusStore.onchange

_.assign focusStore $ object
  :onchange $ \ ()
    @emit :change

  :get $ \ () store

= module.exports focusStore
