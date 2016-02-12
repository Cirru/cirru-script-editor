
var
  hsl $ require :hsl
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

  :componentDidUpdate $ \ ()
    var
      target $ @state.model.get :focus
      targetId $ ... target (unshift :leaf) (join :-)
      targetEl $ document.getElementById targetId
    -- "|has bug, wait for new frame"
    requestAnimationFrame $ \ ()
      targetEl.focus
    return

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :dispatch $ \ (type data)
    console.log :dispatch type data
    var
      newStore $ updater @state.model type (Immutable.fromJS data)
    console.log
      ... newStore (get :tree) (toJS)
      ... newStore (get :focus) (toJS)
    @setState $ {} :model newStore

  :render $ \ ()
    div ({} :className :cirru-editor :onKeyDown @onKeyDown)
      Expr $ {}
        :expr $ @state.model.get :tree
        :coord (Immutable.List)
        :inline false
        :dispatch @dispatch
        :isNeck false
