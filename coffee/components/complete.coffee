
React = require 'react'
$ = React.DOM

module.exports = React.createClass
  displayName: 'Complete'

  render: ->
    $.div className: 'cirru-complete',
      "Complete"