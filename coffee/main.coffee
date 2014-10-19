
React = require 'react'

Editor = require './components/editor'

rawData = localStorage.getItem('cirru-editor') or '[]'
ast = JSON.parse rawData
window.onbeforeunload = ->
  rawData = JSON.stringify ast
  localStorage.setItem 'cirru-editor', rawData

console.log ast

editor = Editor
  cirru: ast
  onAstChange: (cirru) ->
    ast = cirru

React.renderComponent editor, document.body
