
= React $ require :react/addons

= astAction $ require :../actions/ast
= detect $ require :../util/detect

= Suggest $ React.createFactory $ require :./suggest

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired

  :getInitialState $ \ () $ object
    :token @props.token

  :onChange $ \ (event)
    console.log :token-update event.target.value @props.coord

  :render $ \ ()
    = width $ detect.textWidth @state.token :14px :Menlo
    = style $ object
      :width $ ++: width :px

    o :input
      object (:className :cirru-token) (:value @state.token) (:style style)
        :onChange @onChange
