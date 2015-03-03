
= React $ require :react/addons
= _ $ require :lodash

= astStore $ require :../store/ast

= search $ require :../util/search

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-suggest

  :propTypes $ object
    :text T.string

  :renderTokens $ \ (tokens)
    tokens.map $ \ (text)
      o :div
        object (:className :cirru-guess) (:key text)
        , text

  :render $ \ ()
    = tokens $ _.unique $ _.flattenDeep $ astStore.get
    = suggestTokens $ search.fuzzyStart tokens @props.text

    o :div
      object (:className :cirru-suggest)
      @renderTokens suggestTokens
