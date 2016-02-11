
var
  React $ require :react
  Immutable $ require :immutable

  schema $ require :../schema

  Expr $ React.createFactory $ require :./expr

  ({}~ div) React.DOM

= module.exports $ React.createClass $ object
  :displayName :cirru-editor

  :propTypes $ object
    :ast React.PropTypes.array.isRequired
    :focus React.PropTypes.array.isRequired
    :onChange React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {}
      :tree (schema.model.get :tree)
      :focus (schema.model.get :focus)

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :dispatch $ \ (type data)
    console.log :dispatch type data

  :render $ \ ()
    div ({} :className :cirru-editor :onKeyDown @onKeyDown)
      Expr $ {} :expr @state.tree :coord (Immutable.List) :inline false
        , :dispatch @dispatch
