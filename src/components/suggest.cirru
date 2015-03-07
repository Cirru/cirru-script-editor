
= React $ require :react/addons

= o React.createElement
= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-suggest

  :propTypes $ object
    :text       T.string
    :onSuggest  T.func
    :select     T.number
    :tokens     T.array

  :onTextClick $ \ (text)
    @props.onSuggest text

  :renderTokens $ \ ()
    @props.tokens.map $ \= (text index)
      = onClick $ \= (event)
        event.preventDefault
        @onTextClick text
      = className :cirru-guess
      if (is index @props.select)
        do $ = className ":cirru-guess is-selected"
      o :div
        object (:className className) (:key text) (:onClick onClick)
        , text

  :render $ \ ()

    o :div
      object (:className :cirru-suggest)
      @renderTokens
