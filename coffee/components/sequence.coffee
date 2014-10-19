
React = require 'react'
$ = React.DOM

$$ = require '../helper'
store = require './store'

Token = require './token'
Caret = require './caret'

module.exports = Sequence = React.createClass
  displayName: 'Sequence'

  getInitialState: ->
    dragging: no
    dropping: no

  onDragStart: (event) ->
    event.stopPropagation()
    event.dataTransfer.setDragImage event.target, 0, 0
    store.caretFocus @props.ast
    @setState dragging: yes

  onDragEnd: (event) ->
    @setState dragging: no

  onDragEnter: (event) ->
    event.stopPropagation()
    event.dataTransfer.dropEffect = 'move'
    @setState dropping: yes

  onDragOver: (event) ->
    event.preventDefault()

  onDragLeave: (event) ->
    @setState dropping: no

  onDrop: (event) ->
    event.stopPropagation()
    @setState dropping: no
    store.dropAt @props.ast

  onClick: (event) ->
    event.stopPropagation()
    store.caretFocus @props.ast

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
      className: $$.concat 'sequence',
        if (not isDeep) then 'all-token'
        if @state.dragging then 'is-dragging'
        if @state.dropping then 'is-dropping'
      draggable: yes
      onDragStart: @onDragStart
      onDragEnd: @onDragEnd
      onDragEnter: @onDragEnter
      onDragLeave: @onDragLeave
      onDragOver: @onDragOver
      stopPropagation: @stopPropagation
      onDrop: @onDrop
      onClick: @onClick
      children