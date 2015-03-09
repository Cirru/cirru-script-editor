
= _ $ require :lodash

= dispatcher $ require :../dispatcher

= exports.focusTo $ \ (coord)
  dispatcher.handleAction $ object
    :type :focus-to
    :coord coord

= exports.updateToken $ \ (coord text)
  dispatcher.handleAction $ object
    :type :update-token
    :coord coord
    :text text

= exports.removeNode $ \ (coord)
  -- "slow down moving and do't trigger back"
  setTimeout $ \= ()
    dispatcher.handleAction $ object
      :type :focus-backward
    dispatcher.handleAction $ object
      :type :remove-node
      :coord coord

= exports.beforeToken $ \ (coord)
  dispatcher.handleAction $ object
    :type :before-token
    :coord coord
  dispatcher.handleAction $ object
    :type :focus-backward

= exports.afterToken $ \ (coord)
  if (_.isEqual coord (array))
    do
      exports.prependToken coord
      return
  dispatcher.handleAction $ object
    :type :after-token
    :coord coord
  dispatcher.handleAction $ object
    :type :focus-forward

= exports.prependToken $ \ (coord)
  dispatcher.handleAction $ object
    :type :prepend-token
    :coord coord
  dispatcher.handleAction $ object
    :type :focus-inside

= exports.packNode $ \ (coord)
  dispatcher.handleAction $ object
    :type :pack-node
    :coord coord
  dispatcher.handleAction $ object
    :type :focus-inside

= exports.unpackExpr $ \ (coord)
  dispatcher.handleAction $ object
    :type :unpack-expr
    :coord coord
  dispatcher.handleAction $ object
    :type :focus-outside
