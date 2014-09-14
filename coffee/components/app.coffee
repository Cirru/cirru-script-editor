
React = require 'react'
$ = React.DOM

module.exports = React.createClass
  displayName: 'app-component'

  render: ->
    $.div {}, 'app here'