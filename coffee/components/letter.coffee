
React = require 'react'
$ = React.DOM

$$ = require '../utils/helper'

module.exports = React.createClass
  displayName: 'Letter'

  render: ->
    l = @props.letter
    $.span
      className: $$.concat 'letter',
        if l is ' ' then 'is-space'
      @props.letter