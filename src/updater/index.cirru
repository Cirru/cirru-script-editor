
var

  logic $ require :./logic

  id $ \ (x) x

= module.exports $ \ (store type data)
  var
    handler $ case type
      :update-token
      :remove-node
      :before-token
      :after-token
      :prepend-token
      :pack-node
      :unpack-expr
      :drop-to
      :focus-to
      :go-left
      :go-right
      :go-up
      :go-down
      else id

  handler store data
