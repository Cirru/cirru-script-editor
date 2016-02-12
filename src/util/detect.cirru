
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
    is (typeof item) :string
