
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

  :onSave $ \ (tree)
    @setState $ {} :tree tree
    localStorage.setItem :cirru-ast $ JSON.stringify tree

  :render $ \ ()
    div ({})
      Editor $ {} :tree @state.tree :onSave @onSave :height window.innerHeight
