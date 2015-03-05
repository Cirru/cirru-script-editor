
= React $ require :react/addons
= _ $ require :lodash

= astStore $ require :../store/ast

= search $ require :../util/search

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-suggest

  :propTypes $ object
    :text       T.string
    :onSuggest  T.func

  :onTextClick $ \ (text)
    @props.onSuggest text

  :renderTokens $ \ (tokens)
    tokens.map $ \= (text)
      = onClick $ \= (event)
        event.preventDefault
        console.log :onTextClick text
        @onTextClick text
      o :div
        object (:className :cirru-guess) (:key text) (:onClick onClick)
        , text

  :render $ \ ()
    = tokens $ _.unique $ _.flattenDeep $ astStore.get
    = suggestTokens $ search.fuzzyStart tokens @props.text

    o :div
      object (:className :cirru-suggest)
      @renderTokens suggestTokens
