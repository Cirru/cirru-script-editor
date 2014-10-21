
React = require 'react'
$ = React.DOM

store = require './store'
$$ = require '../helper'

module.exports = React.createClass
  displayName: 'Token'

  getInitialState: ->
    dragging: no
    dropping: no

  componentDidMount: ->
    token = @refs.token.getDOMNode()
    sel = getSelection()
    sel.removeAllRanges()
    r = new Range
    if token.firstChild?
      r.selectNode token.firstChild
      sel.addRange r
      sel.collapseToEnd()

  onKeyUp: (event) ->
    if event.keyCode in [38, 40, 13]
      return
    text = @refs.token.getDOMNode().innerText
    store.updateToken text

  onClick: (event) ->
    event.stopPropagation()
    store.caretFocus @props.ast

  onKeyDown: (event) ->
    switch event.keyCode
      when 13
        store.complete()
        event.preventDefault()
      when 8 # backspace
        store.removeToken()
      when 9 # tab
        store.newCaretFromToken()
        event.preventDefault()
      when 38 # up
        store.moveNthUp()
        event.preventDefault()
      when 40 # down
        store.moveNthDown()
        event.preventDefault()

  onDrop: (event) ->
    event.stopPropagation()
    store.dropAt @props.ast
    @setState dropping: no

  onDragStart: (event) ->
    event.stopPropagation()
    event.dataTransfer.setDragImage event.target, 0, 0
    store.caretFocus @props.ast
    @setState dragging: yes

  onDragEnd: (event) ->
    @setState dragging: no

  onDragEnter: (event) ->
    event.dataTransfer.dropEffect = 'move'
    @setState dropping: yes

  onDragOver: (event) ->
    event.preventDefault()

  onDragLeave: (event) ->
    event.stopPropagation()
    @setState dropping: no

  render: ->
    $.div
      className: $$.concat 'token',
        if @state.dragging then 'is-dragging'
        if @state.dropping then 'is-dropping'
      draggable: yes
      contentEditable: yes
      ref: 'token'
      onKeyUp: @onKeyUp, onDragStart: @onDragStart
      onKeyDown: @onKeyDown
      onClick: @onClick
      onDragStart: @onDragStart
      onDragEnd: @onDragEnd
      onDragEnter: @onDragEnter
      onDragLeave: @onDragLeave
      onDragOver: @onDragOver
      onDrop: @onDrop
      @props.ast.data
