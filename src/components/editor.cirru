
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

  :propTypes $ {}
    :tree $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :onSave React.PropTypes.func.isRequired
    :height React.PropTypes.number.isRequired

  :getInitialState $ \ ()
    {}
      :model $ schema.model.set :tree @props.tree

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
    -- console.log :dispatch type dat
    var
      newStore $ updater @state.model type (Immutable.fromJS data)
    -- console.log
      ... newStore (get :tree) (toJS)
      ... newStore (get :focus) (toJS)
    @setState $ {} :model newStore

  :onSave $ \ (event)
    @props.onSave (@state.model.get :tree)

  :render $ \ ()
    div ({} :className :cirru-editor :onKeyDown @onKeyDown :style (@styleRoot))
      div ({} :className :cirru-toolbar)
        cond
          not $ Immutable.is (@state.model.get :tree) @props.tree
          div ({} :className :cirru-tool-button :onClick @onSave) ":save"
      div ({} :className :cirru-container)
        div ({} :style (@styleSpace))
        Expr $ {}
          :expr $ @state.model.get :tree
          :coord (Immutable.List)
          :inline false
          :dispatch @dispatch
        div ({} :style (@styleSpace))

  :styleRoot $ \ ()
    {} :height @props.height

  :styleSpace $ \ ()
    {} :height $ - @props.height 100
