
React = require 'react'
$ = React.DOM

store = require './store'

module.exports = React.createClass
  displayName: 'Token'

  componentDidMount: ->
    token = @refs.token.getDOMNode()
    sel = getSelection()
    sel.removeAllRanges()
    r = new Range
    r.selectNode token.firstChild
    sel.addRange r
    sel.collapseToEnd()

  onKeyUp: (event) ->
    text = @refs.token.getDOMNode().innerText
    store.updateToken text

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  onClick: ->
    store.caretFocus @props.ast

  onKeyDown: (event) ->
    if event.keyCode is 13
      event.preventDefault()
      store.newSequenceFromToken()
    else if event.keyCode is 8 # backspace
      store.removeToken()
    else if event.keyCode is 9 # tab
      store.newCaretFromToken()
      event.preventDefault()

  render: ->
    $.div
      contentEditable: yes
      className: 'token', draggable: yes
      ref: 'token'
      onKeyUp: @onKeyUp, onDragStart: @onDragStart
      onKeyDown: @onKeyDown
      onClick: @onClick
      @props.ast.data
