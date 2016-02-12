
var
  React $ require :react
  Immutable $ require :immutable
  _ $ require :lodash
  cx $ require :classnames

  Token $ React.createFactory $ require :./token
  div $ React.createFactory :div

  keydownCode $ require :../util/keydown-code
  detect $ require :../util/detect

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :coord $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :inline React.PropTypes.bool.isRequired
    :dispatch React.PropTypes.func.isRequired
    :focusTo React.PropTypes.func.isRequired

  :getInitialState $ \ () $ {}

  :onClick $ \ (event)
    event.stopPropagation
    @props.focusTo @props.coord

  :onKeyDown $ \ (event)
    event.stopPropagation
    switch event.keyCode
      keydownCode.cancel
        event.preventDefault
        @props.dispatch :remove-node @props.coord
      keydownCode.enter
        switch true
          event.shiftKey
            @props.dispatch :before-token @props.coord
          (or event.metaKey event.ctrlKey)
            @props.dispatch :prepend-token @props.coord
          else
            @props.dispatch :after-token @props.coord
      keydownCode.tab
        if event.shiftKey
          do
            @props.dispatch :unpack-expr @props.coord
          do
            @props.dispatch :pack-node @props.coord
      keydownCode.left
        @props.dispatch :go-left @props.coord
        event.preventDefault
      keydownCode.right
        @props.dispatch :go-right @props.coord
        event.preventDefault
      keydownCode.up
        @props.dispatch :go-up @props.coord
        event.preventDefault
      keydownCode.down
        @props.dispatch :go-down @props.coord
        event.preventDefault
    return

  :render $ \ ()
    var
      className $ cx $ object
        :cirru-expr true
        :is-inline @props.inline
        :is-empty $ is @props.expr.size 0
        :is-root $ is @props.coord.size 0
      isLastList true

    div
      object (:className className) (:onClick @onClick)
        :id $ ... @props.coord (unshift :leaf) (join :-)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root

      @props.expr.map $ \\ (item index)
        var isLastInline $ not isLastList
        var isLastList $ _.isArray item
        cond (_.isString item)
          Token $ object (:token item) (:key index)
            :coord $ @props.coord.push index
            :dispatch @props.dispatch
            :focusTo @props.focusTo
          Expr $ object (:expr item) (:key index)
            :coord $ @props.coord.push index
            :dispatch @props.dispatch
            :focusTo @props.focusTo
            :inline $ and
              detect.isPlain item
              and (> @props.coord.size 0) isLastInline

var Expr $ React.createFactory module.exports
