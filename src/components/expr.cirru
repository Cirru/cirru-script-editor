
= React $ require :react/addons

= Token $ React.createFactory $ require :./token

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :ast T.array.isRequired

  :render $ \ ()
    o :div
      object (:className :cirru-expr)
      , :cirru-expr
