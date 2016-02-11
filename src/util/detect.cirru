
var
  _ $ require :lodash

  canvas $ document.createElement :canvas

  ctx $ canvas.getContext :2d

= exports.textWidth $ \ (text size family)
  ctx.save
  = ctx.font $ + size ": " family
  var width $ . (ctx.measureText text) :width
  ctx.restore
  Math.ceil width

= exports.isPlain $ \ (ast)
  ast.every $ \ (item)
    _.isString item

var containsHelper $ \ (a b)
  if (is b.length 0)
    do $ return true
  if (is (. a 0) (. b 0))
    do $ containsHelper (a.slice 1) (b.slice 1)
    do $ return false
  return

= exports.contains $ \ (a b)
  containsHelper a b
