
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
  dispatcher.handleAction $ object
    :type :token-forward

= exports.newExpr $ \ (coord)
  dispatcher.handleAction $ object
    :type :new-expr
    :coord coord
  dispatcher.handleAction $ object
    :type :expr-forward

= exports.removeToken $ \ (coord)
  dispatcher.handleAction $ object
    :type :remove-token
    :coord coord
  dispatcher.handleAction $ object
    :type :token-backward
