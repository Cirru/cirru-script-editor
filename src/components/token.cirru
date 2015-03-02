
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

  :onChange $ \ (event)
    = text event.target.value
    astAction.updateToken @props.coord text

  :render $ \ ()
    = width $ detect.textWidth @props.token :14px :Menlo
    = style $ object
      :width $ ++: width :px

    o :input
      object (:className :cirru-token) (:value @props.token) (:style style)
        :onChange @onChange
