
= dispatcher $ require :../dispatcher

= exports.updateToken $ \ (coord text)
  dispatcher.handleAction $ object
    :type :update-token
    :coord coord
    :text text

= exports.newToken $ \ (coord)
  dispatcher.handleAction $ object
    :type :new-token
    :coord coord

= exports.newExpr $ \ (coord)
  dispatcher.handleAction $ object
    :type :new-expr
    :coord coord
