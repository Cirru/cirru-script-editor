
var
  React $ require :react
  cx $ require :classnames
  Immutable $ require :immutable

  search $ require :../util/search

  detect $ require :../util/detect
  keydownCode $ require :../util/keydown-code

  span $ React.createFactory :span
  input $ React.createFactory :input

  T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ {}

  :propTypes $ object
    :token T.string.isRequired
    :isHead T.bool.isRequired
    :coord $ . (T.instanceOf Immutable.List) :isRequired
    :dispatch T.func.isRequired
    :mixpanelTrack T.func.isRequired

  :isCaretAhead $ \ ()
    var inputEl @refs.input
    is inputEl.selectionStart 0

  :isCaretBehind $ \ ()
    var inputEl @refs.input
    is inputEl.selectionEnd inputEl.value.length

  :onChange $ \ (event)
    var text event.target.value
    @props.dispatch :update-token $ {}
      :coord @props.coord
      :text text

  :onClick $ \ (event)
    @props.dispatch :focus-to @props.coord
    event.stopPropagation

  :onDoubleClick $ \ (event)
    event.stopPropagation

  :onKeyDown $ \ (event)
    var keyCode event.keyCode
    switch keyCode
      keydownCode.enter
        event.stopPropagation
        if event.shiftKey
          do $ @props.dispatch :before-token @props.coord
          do $ @props.dispatch :after-token @props.coord
      keydownCode.space
        event.stopPropagation
        if (not event.shiftKey)
          do
            @props.dispatch :after-token @props.coord
            event.preventDefault
      keydownCode.tab
        event.preventDefault
        event.stopPropagation
        if event.shiftKey
          do $ @props.dispatch :unpack-node @props.coord
          do $ @props.dispatch :pack-node @props.coord
      keydownCode.cancel
        event.stopPropagation
        if (is @props.token :)
          do
            @props.dispatch :remove-node @props.coord
            event.stopPropagation
            event.preventDefault
      keydownCode.left
        event.stopPropagation
        if (@isCaretAhead)
          do $ @props.dispatch :go-left @props.coord
      keydownCode.right
        event.stopPropagation
        if (@isCaretBehind)
          do $ @props.dispatch :go-right @props.coord
      keydownCode.up
        event.stopPropagation
        if (@isCaretAhead)
          do $ @props.dispatch :go-up @props.coord
      keydownCode.down
        event.stopPropagation
        if (@isCaretBehind)
          do $ @props.dispatch :go-right @props.coord
    return

  :render $ \ ()
    var
      width $ detect.textWidth @props.token :15px ":Source Code Pro, Menlo, Consolas, monospace"
      style $ object
        :width $ + (+ width 4) :px
      className $ cx $ object
        :cirru-token true
        :is-fuzzy $ or (is @props.token :) (? (@props.token.match /\s))
        :is-head @props.isHead

    input
      {} (:value @props.token) (:style style) (:ref :input)
        :onDoubleClick @onDoubleClick
        :spellCheck false
        :className className
        :id $ ... @props.coord (unshift :leaf) (join :-)
        :onChange @onChange
        :onKeyDown @onKeyDown
        :onClick @onClick
