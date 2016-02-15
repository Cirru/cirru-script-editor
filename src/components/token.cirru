
var
  React $ require :react
  _ $ require :lodash
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

  :getInitialState $ \ () $ object
    :select 0

  :propTypes $ object
    :token T.string.isRequired
    :inline T.bool.isRequired
    :isHead T.bool.isRequired
    :coord $ . (T.instanceOf Immutable.List) :isRequired
    :dispatch T.func.isRequired

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
    @setState $ object
      :disableSuggest false
      :select 0

  :onClick $ \ (event)
    @props.dispatch :focus-to @props.coord
    event.stopPropagation

  :onBlur $ \ (event)
    @setState $ object
      :disableSuggest true

  :onRootClick $ \ (event)
    event.stopPropagation

  :onKeyDown $ \ (event)
    event.stopPropagation
    var keyCode event.keyCode
    switch keyCode
      keydownCode.esc
        @setState $ object (:disableSuggest true)
        return undefined
      keydownCode.enter
        if event.shiftKey
          do $ @props.dispatch :before-token @props.coord
          do $ @props.dispatch :after-token @props.coord
        @setState $ object
          :disableSuggest true
      keydownCode.space
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
        if (is @props.token :)
          do
            @props.dispatch :remove-node @props.coord
            event.stopPropagation
            event.preventDefault
      keydownCode.left
        if (@isCaretAhead)
          do $ @props.dispatch :go-left @props.coord
      keydownCode.right
        if (@isCaretBehind)
          do $ @props.dispatch :go-right @props.coord
      keydownCode.up
        if (@isCaretAhead)
          do $ @props.dispatch :go-up @props.coord
      keydownCode.down
        if (@isCaretBehind)
          do $ @props.dispatch :go-right @props.coord
    return

  :render $ \ ()
    var
      width $ detect.textWidth @props.token :14px :Menlo
      style $ object
        :width $ + (+ width 8) :px
      className $ cx $ object
        :cirru-token true
        :is-fuzzy $ or (is @props.token :) (? (@props.token.match /\s))
        :is-head @props.isHead

    input
      {} (:value @props.token) (:style style) (:ref :input)
        :className className
        :onClick @onRootClick
        :id $ ... @props.coord (unshift :leaf) (join :-)
        :onBlur @onBlur
        :onChange @onChange
        :onKeyDown @onKeyDown
        :onClick @onClick
