
var
  React $ require :react
  _ $ require :lodash
  cx $ require :classnames

  astStore    $ require :../store/ast

  search $ require :../util/search
  list $ require :../util/list

  astActions $ require :../actions/ast

  detect $ require :../util/detect
  keydownCode $ require :../util/keydown-code

  Suggest $ React.createFactory $ require :./suggest
  span $ React.createFactory :span
  input $ React.createFactory :input

  mixinListenTo $ require :../mixins/listen-to

  T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :disableSuggest true
    :select 0

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired
    :focus T.array.isRequired

  :componentDidMount $ \ ()
    @setFocus

  :componentDidUpdate $ \ ()
    @setFocus

  :shouldComponentUpdate $ \ (props state)
    if (isnt props.token @props.token)
      do $ return true
    if (not $ _.isEqual props.focus @props.focus)
      do
        if (_.isEqual props.focus @props.coord)
          do $ return true
        if (_.isEqual props.focus props.coord)
          do $ return true
    if (not $ _.isEqual state @state)
      do $ return true
    return false

  :setFocus $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        var inputEl @refs.input
        if (is document.activeElement inputEl)
          do $ return
        inputEl.focus
        = inputEl.selectionStart inputEl.value.length
        = inputEl.selectionEnd inputEl.value.length
    return

  :getTokens $ \ ()
    var tokens $ _.flattenDeep $ astStore.get
    = tokens $ tokens.filter $ \ (item)
      > item.length 2
    = tokens $ list.removeOne tokens @props.token
    var
      uniqueTokens $ _.unique tokens
    search.fuzzyStart uniqueTokens @props.token

  :inSuggest $ \ ()
    if @state.disableSuggest
      do $ return false

    var tokens (@getTokens)
    if (is tokens.length 0)
      do $ return false

    return true

  :getCurrentGuess $ \ ()
    var tokens (@getTokens)
    . tokens @state.select

  :selectPrev $ \ ()
    var tokens $ @getTokens
    if (> @state.select 0)
      do $ @setState $ object $ :select $ - @state.select 1
      do $ @setState $ object $ :select $ - tokens.length 1
    return

  :selectNext $ \ ()
    var tokens $ @getTokens
    if (>= @state.select (- tokens.length 1))
      do $ @setState $ object $ :select 0
      do $ @setState $ object $ :select $ + @state.select 1
    return

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

  :onSuggest $ \ (text)
    astActions.updateToken @props.coord text
    @setState $ object
      :disableSuggest true

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
      keydownCode.up
        if (@inSuggest)
          do
            event.preventDefault
            @selectPrev
          do $ if (@isCaretAhead)
            do $ astActions.goUp @props.coord
      keydownCode.down
        if (@inSuggest)
          do
            event.preventDefault
            @selectNext
          do $ if (@isCaretBehind)
            do $ astActions.goDown @props.coord
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
          :onBlur @onBlur
          :onChange @onChange
          :onKeyDown @onKeyDown
          :onClick @onClick
      cond (and (_.isEqual @props.focus @props.coord) (not @state.disableSuggest))
        Suggest $ object
          :text @props.token
          :onSuggest @onSuggest
          :tokens tokens
          :select @state.select
