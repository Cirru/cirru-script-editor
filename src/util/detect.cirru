
= _ $ require :lodash

= canvas $ document.createElement :canvas

= ctx $ canvas.getContext :2d

= exports.textWidth $ \ (text size family)
  ctx.save
  = ctx.font $ ++: size ": " family
  = width $ . (ctx.measureText text) :width
  ctx.restore
  , width

= exports.isPlain $ \ (ast)
  ast.every $ \ (item)
    _.isString item

= containsHelper $ \ (a b)
  if (is b.length 0)
    do $ return true
  if (is (. a 0) (. b 0))
    do $ containsHelper (a.slice 0 -1) (b.slice 0 -1)
    do $ return false

= exports.contains $ \ (a b)
  containsHelper a b
