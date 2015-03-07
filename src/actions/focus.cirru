
= dispatcher $ require :../dispatcher

= exports.focus $ \ (coord)
  dispatcher.handleAction $ object
    :type :focus
    :coord coord
