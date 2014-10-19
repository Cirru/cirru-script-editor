
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
    switch event.keyCode
      when 9 # tab
        event.preventDefault()
      when 8 # backspace
        if text.length is 0
          store.removeNode()
      when 37 # left
        store.caretLeft()
      when 39 # right
        store.caretRight()
      when 38 # up
        store.caretUp()
      when 40
        store.caretDown()

  render: ->
    $.span
      ref: 'root'
      className: 'caret'
      contentEditable: yes
      onKeyUp: @onKeyUp
      onKeyDown: @onKeyDown