
= React $ require :react/addons
= _ $ require :lodash

= astStore $ require :../store/ast

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-suggest

  :render $ \ ()
    = tokens $ _.unique $ _.flattenDeep $ astStore.get
    console.log tokens

    o :div
      object (:className :cirru-suggest)
