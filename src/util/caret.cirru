
= exports.forward $ \ (ast coord)
  = last $ . coord (- coord.length 1)
  = before $ coord.slice 0 -1
  before.concat (+ last 1)

= exports.backward $ \ (ast coord)
  = last $ . coord (- coord.length 1)
  = before $ coord.slice 0 -1
  if (> last 0)
    do $ before.concat (- last 1)
    do $ return before

= exports.inside $ \ (ast coord)
  coord.concat 0

= exports.outside $ \ (ast coord)
  coord.slice 0 -1
