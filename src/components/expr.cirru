
var
  hsl $ require :hsl
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable
  cx $ require :classnames

  Token $ React.createFactory $ require :./token
  div $ React.createFactory :div

  keydownCode $ require :../util/keydown-code
  detect $ require :../util/detect
  format $ require :../util/format

  bind $ \\ (v k) (k v)

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :coord $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :displayKind React.PropTypes.string.isRequired
    :dispatch React.PropTypes.func.isRequired
    :level React.PropTypes.number.isRequired
    :eventTrack React.PropTypes.func.isRequired

  :getInitialState $ \ () $ {}
    :isFolded false

  :onClick $ \ (event)
    event.stopPropagation
    @props.dispatch :focus-to @props.coord

  :onDoubleClick $ \ (event)
    event.stopPropagation
    if (not @state.isFolded) $ do
      @setState $ {} :isFolded true
      @props.eventTrack ":folded expr"
    return

  :onUnfold $ \ (event)
    @setState $ {} :isFolded false

  :onKeyDown $ \ (event)
    switch event.keyCode
      keydownCode.cancel
        event.stopPropagation
        event.preventDefault
        @props.dispatch :remove-node @props.coord
      keydownCode.enter
        event.stopPropagation
        switch true
          event.shiftKey
            @props.dispatch :before-token @props.coord
          (or event.metaKey event.ctrlKey)
            @props.dispatch :prepend-token @props.coord
          else
            if (> @props.coord.size 1) $ do
              @props.dispatch :after-token @props.coord
      keydownCode.tab
        event.stopPropagation
        if event.shiftKey
          do
            @props.dispatch :unpack-expr @props.coord
          do
            @props.dispatch :pack-node @props.coord
      keydownCode.left
        event.stopPropagation
        @props.dispatch :go-left @props.coord
        event.preventDefault
      keydownCode.right
        event.stopPropagation
        @props.dispatch :go-right @props.coord
        event.preventDefault
      keydownCode.up
        event.stopPropagation
        @props.dispatch :go-up @props.coord
        event.preventDefault
      keydownCode.down
        event.stopPropagation
        event.preventDefault
        if event.shiftKey
          do $ @props.dispatch :go-down-tail @props.coord
          do $ @props.dispatch :go-down @props.coord
      keydownCode.space
        event.stopPropagation
        if (or event.shiftKey event.altKey)
          do
            @props.dispatch :before-token @props.coord
            event.preventDefault
          do
            if (> @props.coord.size 1) $ do
              @props.dispatch :after-token @props.coord
            event.preventDefault
      (keycode :d)
        if
          and event.shiftKey event.metaKey
          do
            event.stopPropagation
            event.preventDefault
            @props.dispatch :duplicate @props.coord
    return

  :renderExpr $ \ ()
    var
      className $ cx
        {}
          :cirru-expr true
          :is-empty $ is @props.expr.size 0
          :is-root $ is @props.coord.size 0
        case @props.displayKind
          :inline :is-simple
          :tail :is-last
          else null

      makeList $ \\ (acc items index lastKind)
        cond (is items.size 0) acc
          bind (items.first) $ \\ (item)
            cond (is (typeof item) :string)
              makeList
                acc.push $ Token $ {} (:token item) (:key index)
                  :coord $ @props.coord.push index
                  :dispatch @props.dispatch
                  :isHead (is index 0)
                  :eventTrack @props.eventTrack
                items.rest
                + index 1
                , :token
              bind
                and
                  detect.isSimple item
                  >= @props.level 0
                \\ (isSimple)
                  makeList
                    acc.push $ Expr $ {} (:expr item) (:key index)
                      :coord $ @props.coord.push index
                      :dispatch @props.dispatch
                      :displayKind $ cond
                        and
                          in ([] :token :shallow-expr) lastKind
                          >= @props.level 0
                        cond
                          and
                            isnt @props.displayKind :tail
                            is index (- @props.expr.size 1)

                          , :tail
                          cond
                            and isSimple
                              is lastKind :token
                            , :inline :normal
                        , :normal
                      :level $ + @props.level 1
                      :eventTrack @props.eventTrack
                    items.rest
                    + index 1
                    cond (detect.isSimple item) :shallow-expr :deep-expr

    div
      {} (:className className) (:onClick @onClick)
        :onDoubleClick @onDoubleClick
        :id $ ... @props.coord (unshift :leaf) (join :-)
        :tabIndex 0
        :onKeyDown @onKeyDown
        :ref :root
      makeList (Immutable.List) @props.expr 0 :none

  :renderFolded $ \ ()
    div
      {} :onClick @onUnfold :onDoubleClick @onDoubleClick
        , :tabIndex null :key :unfocused
        , :className ":cirru-expr is-folded"
      format.plain @props.expr

  :render $ \ ()
    cond @state.isFolded
      @renderFolded
      @renderExpr

var Expr $ React.createFactory module.exports
