
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

  mixinListenTo $ require :../mixins/listen-to

  T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :select 0

  :propTypes $ object
    :token T.string.isRequired
    :coord $ . (T.instanceOf Immutable.List) :isRequired
    :focus $ . (T.instanceOf Immutable.List) :isRequired
    :dispatch T.func.isRequired

  :isCaretAhead $ \ ()
    var inputEl @refs.input
    is inputEl.selectionStart 0

  :isCaretBehind $ \ ()
    var inputEl @refs.input
    is inputEl.selectionEnd inputEl.value.length

  :onChange $ \ (event)
    var text event.target.value
    astActions.updateToken @props.coord text
    @setState $ object
      :disableSuggest false
      :select 0

  :onClick $ \ (event)
    astActions.focusTo @props.coord

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
        var tokens (@getTokens)
        if (@inSuggest)
          do
            @onSuggest $ @getCurrentGuess
            @setState $ object
              :disableSuggest true
          do
            if event.shiftKey
              do $ astActions.beforeToken @props.coord
              do $ astActions.afterToken @props.coord
            @setState $ object
              :disableSuggest true
      keydownCode.tab
        event.preventDefault
        if event.shiftKey
          do $ astActions.unpackExpr $ @props.coord.slice 0 -1
          do $ astActions.packNode @props.coord
      keydownCode.cancel
        if (is @props.token :)
          do
            astActions.removeNode @props.coord
            event.stopPropagation
            event.preventDefault
      keydownCode.left
        if (@isCaretAhead)
          do $ astActions.goLeft @props.coord
      keydownCode.right
        if (@isCaretBehind)
          do $ astActions.goRight @props.coord
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
      width $ detect.textWidth @props.token :14px :Menlo
      style $ object
        :width $ + (+ width 8) :px
      tokens (@getTokens)
      className $ cx $ object
        :cirru-token true
        :is-fuzzy $ or (is @props.token :) (? (@props.token.match /\s))

    span
      object (:className className) (:onClick @onRootClick) (:tabIndex 0)
      input
        object (:value @props.token) (:style style) (:ref :input)
          :id $ ... @props.coord (unshift :leaf) (join :-)
          :onBlur @onBlur
          :onChange @onChange
          :onKeyDown @onKeyDown
          :onClick @onClick
