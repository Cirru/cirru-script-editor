
React = require 'react'

Editor = require './components/editor'

editor = Editor
  cirru: []
  onAstChange: (code) ->
    console.log 'Cirru AST change:', code

React.renderComponent editor, document.body
