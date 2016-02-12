
var

  logic $ require :./logic

  id $ \ (x) x

= module.exports $ \ (store type data)
  var
    handler $ case type
      :update-token logic.updateToken
      :remove-node logic.removeNode
      :before-token logic.beforeToken
      :after-token logic.afterToken
      :prepend-token logic.prependToken
      :pack-node logic.packNode
      :unpack-expr logic.unpackExpr
      :focus-to logic.focusTo
      :go-left logic.goLeft
      :go-right logic.goRight
      :go-up logic.goUp
      :go-down logic.goDown
      else id

  handler store data
