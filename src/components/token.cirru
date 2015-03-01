
= React $ require :react/addons

= Suggest $ React.createFactory $ require :./suggest

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :render $ \ ()
    o :div
      object
      , :cirru-token
