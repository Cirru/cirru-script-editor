
var
  React $ require :react
  Immutable $ require :immutable

  ({}~ div) React.DOM

  Editor $ React.createFactory $ require :./editor

var cachedAst $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

= module.exports $ React.createClass $ object

  :displayName :container

  :getInitialState $ \ ()
    {}
      :tree $ or (Immutable.fromJS cachedAst) (Immutable.List)
      :height window.innerHeight
      :clipboard null

  :componentDidMount $ \ ()
    window.addEventListener :resize @onResize

  :componentWillUnmount $ \ ()
    window.removeEventListener :resize @onResize

  :onResize $ \ ()
    @setState $ {} :height window.innerHeight

  :onSave $ \ (tree)
    @setState $ {} :tree tree
    localStorage.setItem :cirru-ast $ JSON.stringify tree

  :onClipboard $ \ (expression)
    @setState $ {} :clipboard expression

  :eventTrack $ \ (name props)
    console.log ":event track:" name props

  :render $ \ ()
    div ({})
      Editor $ {} :tree @state.tree :onSave @onSave :height @state.height
        , :eventTrack @eventTrack :clipboard @state.clipboard
        , :onClipboard @onClipboard
