
React = require 'react'
$ = React.DOM

Letter = require './letter'

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

  render: ->
    letters = @props.ast.value.split('').map (letter) =>
      Letter letter: letter
    $.div
      className: 'token', draggable: yes
      ref: 'token', onKeyUp: @updateToken, onDragStart: @onDragStart
      letters