
var
  hsl $ require :hsl
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable

  schema $ require :../schema
  updater $ require :../updater

  Expr $ React.createFactory $ require :./expr
  Summary $ React.createFactory $ require :./summary

  ({}~ div) React.DOM

= module.exports $ React.createClass $ object
  :displayName :cirru-editor

  :propTypes $ {}
    :tree $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :onSave React.PropTypes.func.isRequired
    :height React.PropTypes.number.isRequired
    :eventTrack React.PropTypes.func

  :getDefaultProps $ \ ()
    {}
      :eventTrack $ \ ()

  :getInitialState $ \ ()
    {}
      :model $ schema.model.set :tree @props.tree
      :pointer 0

  :componentDidUpdate $ \ ()
    var
      target $ @state.model.get :focus
      targetId $ ... target (unshift :leaf) (join :-)
      targetEl $ document.getElementById targetId

    -- "|has bug, wait for new frame"
    requestAnimationFrame $ \ ()
      if (? targetEl) $ do
        targetEl.focus
      return
    return

  :dispatch $ \ (type data)
    -- console.log :dispatch type data
    var
      newStore $ updater @state.model type (Immutable.fromJS data)
    -- console.log
      newStore @state.model
      ... newStore (get :tree) (toJS)
      ... newStore (get :focus) (toJS)
    @setState $ {} :model newStore
    @props.eventTrack (+ ":dispatch " type)

  :onMovePointer $ \ (pointer)
    @setState $ {} :pointer pointer

  :onSave $ \ (event)
    @props.onSave (@state.model.get :tree)

  :onLineAdd $ \ (event)
    var
      tree $ @state.model.get :tree
      pointer $ cond event.shiftKey @state.pointer (+ 1 @state.pointer)

    @dispatch :create-line pointer
    @onMovePointer (cond (is tree.size 0) 0 pointer)
    @props.eventTrack :line-add

  :onLineRm $ \ (event)
    var
      tree $ @state.model.get :tree
    if (tree.has @state.pointer) $ do
      @dispatch :remove-node $ Immutable.fromJS $ [] @state.pointer
      @onMovePointer (- @state.pointer 1)
      @props.eventTrack :line-add
    return

  :onKeyDown $ \ (event)
    if
      and event.metaKey
        is (keycode event.keyCode) :s
      do
        event.preventDefault
        @props.onSave (@state.model.get :tree)
    return

  :render $ \ ()
    div ({} :className :cirru-editor :style (@styleRoot) :onKeyDown @onKeyDown)
      div ({} :className :cirru-toolbar)
        div ({} :className :cirru-tool-button :onClick @onLineAdd) :add
        div ({} :className :cirru-tool-button :onClick @onLineRm) :rm
        cond
          not $ Immutable.is (@state.model.get :tree) @props.tree
          div ({} :className :cirru-tool-button :onClick @onSave) :save
      Summary $ {}
        :expr $ @state.model.get :tree
        :pointer @state.pointer
        :onMovePointer @onMovePointer
        :dispatch @dispatch
        :eventTrack @props.eventTrack
      div ({} :className :cirru-container)
        div ({} :style (@styleSmallSpace))
        cond
          ... @state.model (get :tree) (has @state.pointer)
          Expr $ {}
            :expr $ ... @state.model
              get :tree
              get @state.pointer
            :coord (Immutable.fromJS $ [] @state.pointer)
            :displayKind :normal
            :dispatch @dispatch
            :level 0
            :eventTrack @props.eventTrack
        div ({} :style (@styleSpace))

  :styleRoot $ \ ()
    {}
      :height @props.height
      :width :100%

  :styleSmallSpace $ \ ()
    {} :height 200

  :styleSpace $ \ ()
    {} :height $ - @props.height 100
