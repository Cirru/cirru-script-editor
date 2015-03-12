
= React $ require :react/addons
= _ $ require :lodash

= Token $ React.createFactory $ require :./token

= astActions $ require :../actions/ast

= keydownCode $ require :../util/keydown-code
= detect $ require :../util/detect

= iconUrl $ require ":../images/cirru-32x32.png"

= o React.createElement
= T React.PropTypes
= cx React.addons.classSet

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr   T.array.isRequired
    :coord  T.array.isRequired
    :focus  T.array.isRequired

  :getInitialState $ \ () $ object
    :isDrag false
    :isDrop false

  :componentDidMount $ \ ()
    @setFocus

  :componentDidUpdate $ \ ()
    @setFocus

  :shoudComponentUpdate $ \ (props state)
    if (isnt props.expr @props.expr)
      do $ return true
    if (isnt props.focus @props.focus)
      do $ return true
    if (isnt state @state)
      do $ return true
    return false

  :setFocus $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        = root $ @refs.root.getDOMNode
        root.focus

  :onClick $ \ (event)
    event.stopPropagation
    astActions.focusTo @props.coord

  :onKeyDown $ \ (event)
    event.stopPropagation
    switch event.keyCode
      keydownCode.cancel
        event.preventDefault
        astActions.removeNode @props.coord
      keydownCode.enter
        cond
          event.shiftKey
            astActions.beforeToken @props.coord
          (or event.metaKey event.ctrlKey)
            astActions.prependToken @props.coord
          else
            astActions.afterToken @props.coord
      keydownCode.tab
        if event.shiftKey
          do $ astActions.unpackExpr @props.coord
          do $ astActions.packNode @props.coord
      keydownCode.left
        astActions.goLeft @props.coord
      keydownCode.right
        astActions.goRight @props.coord
      keydownCode.up
        astActions.goUp @props.coord
      keydownCode.down
        astActions.goDown @props.coord
      keydownCode.z
        if (or event.metaKey event.ctrlKey)
          do
            event.preventDefault
            if event.shiftKey
              do $ astActions.redo
              do $ astActions.undo

  :onDragOver $ \ (event)
    event.preventDefault

  :onDragStart $ \ (event)
    = img $ document.createElement :img
    = img.src iconUrl
    event.dataTransfer.setDragImage img 16 16
    event.stopPropagation
    astActions.focusTo @props.coord
    @setState $ object (:isDrag true)

  :onDragEnd $ \ (event)
    @setState $ object (:isDrag false)

  :onDragEnter $ \ (event)
    @setState $ object (:isDrop true)

  :onDragLeave $ \ (event)
    @setState $ object (:isDrop false)

  :onDrop $ \ (event)
    event.stopPropagation
    @setState $ object (:isDrop false)
    astActions.dropTo @props.coord

  :render $ \ ()
    = className $ cx $ object
      :cirru-expr true
      :is-plain $ detect.isPlain @props.expr
      :is-drag @state.isDrag
      :is-drop @state.isDrop

    o :div
      object (:className className) (:draggable true) (:onClick @onClick)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root
        :onDragOver @onDragOver
        :onDragStart @onDragStart
        :onDragEnd @onDragEnd
        :onDragEnter @onDragEnter
        :onDragLeave @onDragLeave
        :onDrop @onDrop
      _.map @props.expr $ \= (item index)
        if (_.isString item)
          do $ Token $ object (:token item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus
          do $ Expr $ object (:expr item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus

= Expr $ React.createFactory module.exports
