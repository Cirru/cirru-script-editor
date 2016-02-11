
var
  _ $ require :lodash

  getHelper $ \ (ast coord)
    cond (> coord.length 0)
      cond (_.isArray ast)
        getHelper (. ast (. coord 0)) (coord.slice 1)
        , undefined
      , ast

= exports.forward $ \ (ast coord)
  var
    last $ . coord (- coord.length 1)
    before $ coord.slice 0 -1
  before.concat (+ last 1)

= exports.backward $ \ (ast coord)
  var
    last $ . coord (- coord.length 1)
    before $ coord.slice 0 -1
  cond (> last 0)
    before.concat (- last 1)
    , before

= exports.inside $ \ (ast coord)
  coord.concat 0

= exports.outside $ \ (ast coord)
  coord.slice 0 -1

= exports.left $ \ (ast coord)
  if (is coord.length 0)
    do $ return coord
  var
    last $ _.last coord
    initial $ _.initial coord
    suppose $ initial.concat (- last 1)
  cond (? (getHelper ast suppose)) suppose initial

= exports.right $ \ (ast coord)
  if (is coord.length 0)
    do $ return coord
  var
    last $ _.last coord
    initial $ _.initial coord
    suppose $ initial.concat (+ last 1)
  cond (? $ getHelper ast suppose) suppose initial

= exports.up $ \ (ast coord)
  _.initial coord

= exports.down $ \ (ast coord)
  var
    suppose $ coord.concat 0
  cond (? $ getHelper ast suppose) suppose coord
