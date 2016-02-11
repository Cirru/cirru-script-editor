
var
  React $ require :react
  _ $ require :lodash
  cx $ require :classnames

  Token $ React.createFactory $ require :./token
  div $ React.createFactory :div

  astActions $ require :../actions/ast

  keydownCode $ require :../util/keydown-code
  detect $ require :../util/detect

  T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr   T.array.isRequired
    :coord  T.array.isRequired
    :focus  T.array.isRequired
    :level  T.number.isRequired
    :inline T.bool.isRequired

  :getInitialState $ \ () $ object

  :componentDidMount $ \ ()
    @setFocus

  :componentDidUpdate $ \ ()
    @setFocus

  :shouldComponentUpdate $ \ (props state)
    if (not (_.isEqual props.expr @props.expr))
      do $ return true
    if (not (_.isEqual props.focus @props.focus))
      do
        if (detect.contains props.focus @props.coord)
          do $ return true
        if (detect.contains @props.focus @props.coord)
          do $ return true
    if (not (_.isEqual state @state))
      do $ return true
    return false

  :setFocus $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        @refs.root.focus
    return

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
        switch true
          (? event.shiftKey)
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
        event.preventDefault
      keydownCode.right
        astActions.goRight @props.coord
        event.preventDefault
      keydownCode.up
        astActions.goUp @props.coord
        event.preventDefault
      keydownCode.down
        astActions.goDown @props.coord
        event.preventDefault
      keydownCode.z
        if (or event.metaKey event.ctrlKey)
          do
            event.preventDefault
            if event.shiftKey
              do $ astActions.redo
              do $ astActions.undo
    return

  :render $ \ ()
    var
      className $ cx $ object
        :cirru-expr true
        :is-inline @props.inline
        :is-empty $ is @props.expr.length 0
        :is-root $ is @props.level 0
      isLastList true

    div
      object (:className className) (:onClick @onClick)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root

      _.map @props.expr $ \\ (item index)
        var isLastInline $ not isLastList
        var isLastList $ _.isArray item
        cond (_.isString item)
          Token $ object (:token item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus
          Expr $ object (:expr item) (:key index)
            :level $ + @props.level 1
            :coord $ @props.coord.concat index
            :focus @props.focus
            :inline $ and
              detect.isPlain item
              and (> @props.level 0) isLastInline

var Expr $ React.createFactory module.exports
