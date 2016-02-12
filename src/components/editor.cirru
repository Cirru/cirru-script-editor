
var
  React $ require :react
  Immutable $ require :immutable

  schema $ require :../schema
  updater $ require :../updater

  Expr $ React.createFactory $ require :./expr

  ({}~ div) React.DOM

= module.exports $ React.createClass $ object
  :displayName :cirru-editor

  :propTypes $ object

  :getInitialState $ \ ()
    {}
      :model schema.model

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :dispatch $ \ (type data)
    console.log :dispatch type data
    var
      newStore $ updater @state.model type (Immutable.fromJS data)
    console.log (newStore.toJS)
    @setState $ {} :model newStore

  :focusTo $ \ (coord)
    console.log (coord.toJS)

  :render $ \ ()
    div ({} :className :cirru-editor :onKeyDown @onKeyDown)
      Expr $ {}
        :expr $ @state.model.get :tree
        :coord (Immutable.List)
        :inline false
        :dispatch @dispatch
        :focusTo @focusTo
