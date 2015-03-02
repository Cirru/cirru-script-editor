
= React $ require :react/addons
= _ $ require :lodash

= Token $ React.createFactory $ require :./token

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-expr

  :propTypes $ object
    :expr T.array.isRequired
    :coord T.array.isRequired

  :render $ \ ()
    o :div
      object (:className :cirru-expr)
      _.map @props.expr $ \= (item index)
        if (_.isString item)
          do $ Token $ object (:token item) (:key index) (:coord $ @props.coord.concat index)
          do $ Expr $ object (:expr item) (:key index) (:coord $ @props.coord.concat index)

= Expr $ React.createFactory module.exports
