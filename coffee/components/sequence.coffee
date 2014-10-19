
React = require 'react'
$ = React.DOM

Token = require './token'
Caret = require './caret'

module.exports = Sequence = React.createClass
  displayName: 'Sequence'

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  render: ->
    isDeep = no
    @props.ast.data.forEach (item) ->
      if item.type is 'sequence'
        isDeep = yes
    if @props.ast.id is 'root'
      isDeep = yes
    if @props.ast.parent?.id is 'root'
      isDeep = yes

    children = []
    if @props.caret.ast is @props.ast
      if @props.caret.index is 0
        children.push Caret key: 'caret'
    @props.ast.data.forEach (item, index) =>
      if item.type is 'sequence'
        children.push Sequence ast: item, key: item.id, caret: @props.caret
      else
        children.push Token ast: item, key: item.id, caret: @props.caret
      if @props.caret.ast is @props.ast
        if (@props.caret.index - 1) is index
          children.push Caret key: 'caret'

    $.div
      className: if isDeep then 'sequence' else 'sequence all-token'
      draggable: yes
      onDragStart: @onDragStart
      children