
React = require 'react'
$ = React.DOM

Token = require './token'
Caret = require './caret'

module.exports = Sequence = React.createClass
  displayName: 'Sequence'

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  render: ->
    children = []
    if @props.caret.ast is @props.ast
      children.push Caret key: 'caret'
    @props.ast.data.forEach (item, index) =>
      if @props.caret.ast is @props.ast
        if @props.caret.index is index
          children.push Caret key: 'caret'
      if item.type is 'sequence'
        children.push Sequence ast: item, key: item.id, caret: @props.caret
      else
        children.push Token ast: item, key: item.id, caret: @props.caret

    $.div className: 'sequence', draggable: yes, onDragStart: @onDragStart,
      children