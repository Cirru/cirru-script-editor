
= _ $ require :lodash

= getHelper $ \ (ast coord)
  if (> coord.length 0)
    do
      = head (. coord 0)
      if (_.isArray ast)
        do $ getHelper (. ast head) (coord.slice 1)
        do $ return undefined
    do $ return ast

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

= exports.left $ \ (ast coord)
  if (is coord.length 0)
    do $ return coord
  = last $ _.last coord
  = initial $ _.initial coord
  = suppose $ initial.concat (- last 1)
  if (? (getHelper ast suppose))
    do suppose
    do initial

= exports.right $ \ (ast coord)
  if (is coord.length 0)
    do $ return coord
  = last $ _.last coord
  = initial $ _.initial coord
  = suppose $ initial.concat (+ last 1)
  if (? $ getHelper ast suppose)
    do suppose
    do initial

= exports.up $ \ (ast coord)
  _.initial coord

= exports.down $ \ (ast coord)
  = suppose $ coord.concat 0
  if (? $ getHelper ast suppose)
    do suppose
    do coord
