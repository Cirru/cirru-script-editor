
React = require 'react'
$ = React.DOM

$$ = require '../helper'

module.exports = React.createClass
  displayName: 'Complete'

  render: ->
    candidates = @props.caret.candidates.map (text, index) =>
      $.div
        className: $$.concat 'cirru-item',
          if index is @props.caret.nth then 'is-chosen'
        key: text
        text

    $.div className: 'cirru-complete',
      candidates