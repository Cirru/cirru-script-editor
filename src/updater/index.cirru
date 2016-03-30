
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
      :prev-line logic.prevLine
      :next-line logic.nextLine
      :prepend-token logic.prependToken
      :pack-node logic.packNode
      :unpack-expr logic.unpackExpr
      :unpack-node logic.unpackNode
      :focus-to logic.focusTo
      :go-left logic.goLeft
      :go-right logic.goRight
      :go-up logic.goUp
      :go-down logic.goDown
      :go-down-tail logic.goDownTail
      else id

  handler store data
