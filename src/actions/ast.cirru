
= dispatcher $ require :../dispatcher

= exports.updateToken $ \ (coord text)
  dispatcher.handleAction $ object
    :type :update-token
    :coord coord
    :text text
