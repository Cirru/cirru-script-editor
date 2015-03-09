
= EventEmitter  $ require :wolfy87-eventemitter
= dispatcher    $ require :../dispatcher

= store $ array 0

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
      if (> last 0)
        do $ = store $ before.concat (- last 1)
        do $ = store before
      focusStore.onchange
    :expr-forward
      = last $ . store (- store.length 1)
      = before $ store.slice 0 -1
      = store $ before.concat (+ last 1) 0
      focusStore.onchange
    :token-in
      = store $ store.concat 0
      focusStore.onchange

_.assign focusStore $ object
  :onchange $ \ ()
    @emit :change

  :get $ \ () store

= module.exports focusStore
