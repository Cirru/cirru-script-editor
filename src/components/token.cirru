
= React $ require :react/addons

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

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired

  :onChange $ \ (event)
    = text event.target.value
    astAction.updateToken @props.coord text
    @setState $ object
      :disableSuggest false

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
    if (is event.keyCode keydownCode.esc)
      @setState $ object (:disableSuggest true)

  :render $ \ ()
    = width $ detect.textWidth @props.token :14px :Menlo
    = style $ object
      :width $ ++: width :px
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