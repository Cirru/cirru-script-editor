
= dispatcher $ require :../dispatcher

= exports.updateToken $ \ (text)
  console.warn ":not implemented updateToken"
  dispatcher.handleAction $ object
    :type :update-token
    :data text
