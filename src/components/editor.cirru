
= React $ require :react/addons

= astStore    $ require :../store/ast

= mixinListenTo $ require :../mixins/listen-to

= Expr $ React.createFactory $ require :./expr

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-editor
  :mixins $ array mixinListenTo

  :getInitialState $ \ () $ object
    :ast $ astStore.get
    :focus $ astStore.getFocus

  :componentDidMount $ \ ()
    @listenTo astStore @setAst

  :setAst $ \ ()
    @setState $ object (:ast $ astStore.get) (:focus $ astStore.getFocus)

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :render $ \ ()
    o :div
      object (:className :cirru-editor) (:onKeyDown @onKeyDown)
      Expr
        object (:expr @state.ast) (:coord $ array) (:focus @state.focus)
