
= React $ require :react/addons
= _ $ require :lodash

= astStore    $ require :../store/ast

= search $ require :../util/search

= astAction $ require :../actions/ast
= focusActions $ require :../actions/focus

= detect $ require :../util/detect
= keydownCode $ require :../util/keydown-code

= Suggest $ React.createFactory $ require :./suggest

= mixinListenTo $ require :../mixins/listen-to

= o React.createElement
= T React.PropTypes
= cx React.addons.classSet

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :disableSuggest false
    :select 0

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired
    :focus T.array.isRequired

  :componentDidMount $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        = input $ @refs.input.getDOMNode
        if (not (is document.activeElement input))
          do $ input.focus

  :getTokens $ \ ()
    = tokens $ _.unique $ _.flattenDeep $ astStore.get
    search.fuzzyStart tokens @props.token

  :inSuggest $ \ ()
    if @state.disableSuggest
      do $ return false

    = tokens (@getTokens)
    if (is tokens.length 0)
      do $ return false

    return true

  :getCurrentGuess $ \ ()
    = tokens (@getTokens)
    . tokens @state.select

  :selectPrev $ \ ()
    = tokens $ @getTokens
    if (> @state.select 0)
      do $ @setState $ object $ :select $ - @state.select 1
      do $ @setState $ object $ :select $ - tokens.length 1

  :selectNext $ \ ()
    = tokens $ @getTokens
    if (>= @state.select (- tokens.length 1))
      do $ @setState $ object $ :select 0
      do $ @setState $ object $ :select $ + @state.select 1

  :onChange $ \ (event)
    = text event.target.value
    astAction.updateToken @props.coord text
    @setState $ object
      :disableSuggest false
      :select 0

  :onSuggest $ \ (text)
    astAction.updateToken @props.coord text

  :onClick $ \ (event)
    focusActions.focus @props.coord

  :onRootClick $ \ (event)
    event.stopPropagation

  :onKeyDown $ \ (event)
    switch event.keyCode
      keydownCode.esc
        @setState $ object (:disableSuggest true)
        return undefined
      keydownCode.enter
        = tokens (@getTokens)
        if (@inSuggest)
          do $ @onSuggest $ @getCurrentGuess
          do $ astAction.newExpr @props.coord
      keydownCode.tab
        astAction.newToken @props.coord
        event.preventDefault
      keydownCode.up
        if (@inSuggest)
          do
            event.preventDefault
            @selectPrev
      keydownCode.down
        if (@inSuggest)
          do
            event.preventDefault
            @selectNext

  :render $ \ ()
    = width $ detect.textWidth @props.token :14px :Menlo
    = style $ object
      :width $ ++: width :px
    = tokens (@getTokens)
    = className $ cx $ object
      :cirru-token true
      :is-focused $ _.isEqual @props.coord @props.focus

    o :span
      object (:className className) (:draggable true) (:onClick @onRootClick)
      o :input
        object (:value @props.token) (:style style) (:ref :input)
          :onFocus @onFocus
          :onBlur @onBlur
          :onChange @onChange
          :onKeyDown @onKeyDown
          :onClick @onClick
      if (and (_.isEqual @props.focus @props.coord) (not @state.disableSuggest))
        Suggest $ object
          :text @props.token
          :onSuggest @onSuggest
          :tokens tokens
          :select @state.select
