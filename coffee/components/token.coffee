
React = require 'react'
$ = React.DOM

module.exports = React.createClass
  displayName: 'Token'

  updateToken: (event) ->
    text = @refs.token.getDOMNode().innerText
    ast = @props.ast
    @props.updateToken
      id: ast.id
      value: text

  onDragStart: (event) ->
    event.dataTransfer.setDragImage event.target, 0, 0

  onKeyDown: (event) ->
    console.log event

  render: ->
    $.div
      contentEditable: yes
      className: 'token', draggable: yes
      ref: 'token', onKeyUp: @updateToken, onDragStart: @onDragStart
      onKeyDown: @onKeyDown
      @props.ast.value