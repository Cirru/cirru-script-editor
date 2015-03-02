
= React $ require :react/addons
= astStore $ require :../store/ast

= mixinListenTo $ require :../mixins/listen-to

= Expr $ React.createFactory $ require :./expr

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-editor
  :mixins $ array mixinListenTo

  :getInitialState $ \ () $ object
    :ast $ astStore.get

  :componentDidMount $ \ ()
    @listenTo astStore @setAst

  :setAst $ \ ()
    @setState $ object
      :ast $ astStore.get

  :render $ \ ()
    o :div
      object (:className :cirru-editor)
      Expr
        object (:expr @state.ast) (:coord $ array)
