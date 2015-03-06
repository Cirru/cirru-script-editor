
= React $ require :react/addons
= _ $ require :lodash

= astStore $ require :../store/ast

= search $ require :../util/search

= astAction $ require :../actions/ast
= detect $ require :../util/detect
= keydownCode $ require :../util/keydown-code

= Suggest $ React.createFactory $ require :./suggest

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :disableSuggest false
    :isFocused false
    :cursor 0

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired

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
    . tokens @state.cursor

  :selectPrev $ \ ()
    = tokens $ @getTokens
    if (> @state.cursor 0)
      do $ @setState $ object $ :cursor $ - @state.cursor 1
      do $ @setState $ object $ :cursor $ - tokens.length 1

  :selectNext $ \ ()
    = tokens $ @getTokens
    if (>= @state.cursor (- tokens.length 1))
      do $ @setState $ object $ :cursor 0
      do $ @setState $ object $ :cursor $ + @state.cursor 1

  :onChange $ \ (event)
    = text event.target.value
    astAction.updateToken @props.coord text
    @setState $ object
      :disableSuggest false
      :cursor 0

  :onSuggest $ \ (text)
    astAction.updateToken @props.coord text

  :onFocus $ \ ()
    @setState $ object (:isFocused true)

  :onBlur $ \ ()
    setTimeout
      \= ()
        @setState $ object (:isFocused false)
      , 100

  :onKeyDown $ \ (event)
    switch event.keyCode
      keydownCode.esc
        @setState $ object (:disableSuggest true)
        return undefined
      keydownCode.enter
        = tokens (@getTokens)
        if (@inSuggest)
          do $ @onSuggest $ @getCurrentGuess
          do $ astAction.newExpr @state.coord
      keydownCode.tab
        astAction.newToken @state.coord
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

    o :span
      object (:className :cirru-token)
      o :input
        object (:value @props.token) (:style style)
          :onFocus @onFocus
          :onBlur @onBlur
          :onChange @onChange
          :onKeyDown @onKeyDown
      if (and @state.isFocused (not @state.disableSuggest))
        Suggest $ object
          :text @props.token
          :onSuggest @onSuggest
          :tokens tokens
          :cursor @state.cursor
