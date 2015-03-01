
= exports.componentWillMount $ \ ()
  = @listeners $ array

= exports.listenTo $ \ (store fn)
  store.addListener :change fn
  @listeners.push $ object
    :remove $ \ ()
      store.removeListener :change fn

= exports.componentWillUnmount $ \ ()
  @listeners.forEach $ \ (listener)
    listener.remove
