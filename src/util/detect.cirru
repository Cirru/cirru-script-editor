
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
