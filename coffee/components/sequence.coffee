
React = require 'react'
$ = React.DOM

Token = require './token'

module.exports = Sequence = React.createClass
  displayName: 'Sequence'

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  render: ->
    children = @props.ast.value.map (item) =>
      if item.type is 'sequence'
        @transferPropsTo Sequence ast: item, key: item.id
      else
        @transferPropsTo Token ast: item, key: item.id

    $.div className: 'sequence', draggable: yes, onDragStart: @onDragStart,
      children