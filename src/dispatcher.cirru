
var
  flux $ require :flux
  _ $ require :lodash

  Dispatcher flux.Dispatcher

  dispatcher $ new Dispatcher

_.assign dispatcher $ object

  :handleAction $ \ (action)
    if window.isCirruLogOn
      do $ console.info :action: action
    @dispatch action

= module.exports dispatcher