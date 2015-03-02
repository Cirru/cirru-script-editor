
= React $ require :react/addons
= astStore $ require :../store/ast

= Expr $ React.createFactory $ require :./expr

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-editor

  :getInitialState $ \ () $ object
    :ast $ astStore.get

  :render $ \ ()
    o :div
      object (:className :cirru-editor)
      Expr
        object (:expr @state.ast) (:coord $ array)
