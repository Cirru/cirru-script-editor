
= flux $ require :flux
= _ $ require :lodash

= Dispatcher flux.Dispatcher

= dispatcher $ new Dispatcher

_.assign dispatcher $ object

  :handleAction $ \ (action)
    console.info :action: action
    @dispatch action

= module.exports dispatcher