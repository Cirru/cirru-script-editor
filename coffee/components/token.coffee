
React = require 'react'
$ = React.DOM

store = require './store'

module.exports = React.createClass
  displayName: 'Token'

  componentDidMount: ->
    @refs.token.getDOMNode().focus()

  updateToken: (event) ->
    text = @refs.token.getDOMNode().innerText

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  onKeyDown: (event) ->
    if event.keyCode is 13
      event.preventDefault()
      store.newSequenceFromToken()
    else if event.keyCode is 9 # backspace
      store.removeToken()
    else if event.keyCode is 8 # tab
      store.newTokenFromToken()

  render: ->
    $.div
      contentEditable: yes
      className: 'token', draggable: yes
      ref: 'token', onKeyUp: @updateToken, onDragStart: @onDragStart
      onKeyDown: @onKeyDown
      onKeyUp: @onKeyUp
      @props.ast.data
