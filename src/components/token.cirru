
= React $ require :react/addons

= astAction $ require :../actions/ast
= detect $ require :../util/detect

= Suggest $ React.createFactory $ require :./suggest

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :disableSuggest false

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
    @setState $ object
      :disableSuggest true

  :render $ \ ()
    = width $ detect.textWidth @props.token :14px :Menlo
    = style $ object
      :width $ ++: width :px
    o :span
      object (:className :cirru-token)
      o :input
        object (:value @props.token) (:style style)
          :onChange @onChange
      if (not @state.disableSuggest)
        Suggest $ object
          :text @props.token
          :onSuggest @onSuggest