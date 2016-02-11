
var
  React $ require :react

  ({}~ div) React.DOM

  T React.PropTypes

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
    @props.tokens.map $ \\ (text index)
      var onClick $ \\ (event)
        event.preventDefault
        @onTextClick text
      var className :cirru-guess
      if (is index @props.select)
        do $ = className ":cirru-guess is-selected"
      div
        object (:className className) (:key text) (:onClick onClick)
        , text

  :render $ \ ()
    div
      object (:className :cirru-suggest)
      @renderTokens
