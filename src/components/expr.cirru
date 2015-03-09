
= React $ require :react/addons
= _ $ require :lodash

= Token $ React.createFactory $ require :./token

= focusStore $ require :../store/focus

= astActions $ require :../actions/ast

= keydownCode $ require :../util/keydown-code
= detect $ require :../util/detect

= o React.createElement
= T React.PropTypes
= cx React.addons.classSet

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr   T.array.isRequired
    :coord  T.array.isRequired
    :focus  T.array.isRequired

  :componentDidMount $ \ ()
    @setFocus

  :componentDidUpdate $ \ ()
    @setFocus

  :setFocus $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        = root $ @refs.root.getDOMNode
        root.focus

  :onClick $ \ (event)
    event.stopPropagation
    astActions.focusTo @props.coord

  :onKeyDown $ \ (event)
    switch event.keyCode
      keydownCode.cancel
        event.stopPropagation
        event.preventDefault
        astActions.removeNode @props.coord
      keydownCode.enter
        event.stopPropagation
        cond
          event.shiftKey
            astActions.beforeToken @props.coord
          (or event.metaKey event.altKey)
            astActions.prependToken @props.coord
          else
            astActions.afterToken @props.coord
      keydownCode.tab
        event.stopPropagation
        if event.shiftKey
          do $ astActions.unpackExpr @props.coord
          do $ astActions.packNode @props.coord

  :render $ \ ()
    = className $ cx $ object
      :cirru-expr true
      :is-plain $ detect.isPlain @props.expr

    o :div
      object (:className className) (:draggable true) (:onClick @onClick)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root
      _.map @props.expr $ \= (item index)
        if (_.isString item)
          do $ Token $ object (:token item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus
          do $ Expr $ object (:expr item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus

= Expr $ React.createFactory module.exports
