
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher

= store $ array

= focusStore $ new EventEmitter

= focusStore.dispatchToken $ dispatcher.register $ \ (action)
  switch action.type
    :focus
      = store action.coord
      focusStore.onchange
    :token-forward
      = last $ . store (- store.length 1)
      = before $ store.slice 0 -1
      = store $ before.concat (+ last 1)
      focusStore.onchange
    :token-backward
      = last $ . store (- store.length 1)
      = before $ store.slice 0 -1
      = store $ before.concat (- last 1)
      focusStore.onchange
    :expr-forward
      = last $ . store (- store.length 1)
      = before $ store.slice 0 -1
      = store $ before.concat (+ last 1) 0
      focusStore.onchange

_.assign focusStore $ object
  :onchange $ \ ()
    @emit :change

  :get $ \ () store

= module.exports focusStore
