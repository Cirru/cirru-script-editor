
var
  React $ require :react
  Immutable $ require :immutable
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

  :getInitialState $ \ () $ {}

  :onClick $ \ (event)
    event.stopPropagation
    @props.dispatch :focus-to @props.coord

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

    div
      object (:className className) (:onClick @onClick)
        :id $ ... @props.coord (unshift :leaf) (join :-)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root

      @props.expr.map $ \\ (item index)
        cond (is (typeof item) :string)
          Token $ object (:token item) (:key index)
            :coord $ @props.coord.push index
            :dispatch @props.dispatch
            :inline @props.inline
            :isHead (is index 0)
          Expr $ object (:expr item) (:key index)
            :coord $ @props.coord.push index
            :dispatch @props.dispatch
            :inline $ is index (- @props.expr.size 1)

var Expr $ React.createFactory module.exports
