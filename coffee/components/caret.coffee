
React = require 'react'
$ = React.DOM

module.exports = React.createClass
  displayName: 'Caret'

  render: ->
    $.span className: 'caret'