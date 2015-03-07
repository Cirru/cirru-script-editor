
= React $ require :react/addons
= _ $ require :lodash

= Token $ React.createFactory $ require :./token

= focusStore $ require :../store/focus

= focusActions $ require :../actions/focus

= o React.createElement
= T React.PropTypes
= cx React.addons.classSet

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr   T.array.isRequired
    :coord  T.array.isRequired
    :focus  T.array.isRequired

  :onClick $ \ (event)
    event.stopPropagation
    focusActions.focus @props.coord

  :render $ \ ()
    = className $ cx $ object
      :cirru-expr true
      :is-focused $ _.isEqual @props.focus @props.coord

    o :div
      object (:className className) (:draggable true) (:onClick @onClick)
      _.map @props.expr $ \= (item index)
        if (_.isString item)
          do $ Token $ object (:token item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus
          do $ Expr $ object (:expr item) (:key index)
            :coord $ @props.coord.concat index
            :focus @props.focus

= Expr $ React.createFactory module.exports
