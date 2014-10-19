
React = require 'react'
$ = React.DOM

store = require './store'

module.exports = React.createClass
  displayName: 'Caret'

  componentDidMount: ->
    @refs.root.getDOMNode().focus()

  onKeyUp: (event) ->
    text = event.target.innerText
    store.typeInCaret text

  onKeyDown: (event) ->
    text = event.target.innerText
    if event.keyCode is 9 # tab
      event.preventDefault()
      return
    if text.length is 0
      if event.keyCode is 8 # backspace
        store.removeNode()

  render: ->
    $.span
      ref: 'root'
      className: 'caret'
      contentEditable: yes
      onKeyUp: @onKeyUp
      onKeyDown: @onKeyDown