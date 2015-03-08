
= React $ require :react/addons

= astStore    $ require :../store/ast
= focusStore  $ require :../store/focus

= mixinListenTo $ require :../mixins/listen-to

= Expr $ React.createFactory $ require :./expr

= o React.createElement

= module.exports $ React.createClass $ object
  :displayName :cirru-editor
  :mixins $ array mixinListenTo

  :getInitialState $ \ () $ object
    :ast $ astStore.get
    :focus $ focusStore.get

  :componentDidMount $ \ ()
    @listenTo astStore @setAst
    @listenTo focusStore @setFocus

  :setAst $ \ ()
    @setState $ object (:ast $ astStore.get)

  :setFocus $ \ ()
    @setState $ object (:focus $ focusStore.get)

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :render $ \ ()
    o :div
      object (:className :cirru-editor) (:onKeyDown @onKeyDown)
      Expr
        object (:expr @state.ast) (:coord $ array) (:focus @state.focus)
