
= canvas $ document.createElement :canvas

= ctx $ canvas.getContext :2d

= exports.textWidth $ \ (text size family)
  ctx.save
  console.log (++: size ": " family)
  = ctx.font $ ++: size ": " family
  = width $ . (ctx.measureText text) :width
  ctx.restore
  , width
