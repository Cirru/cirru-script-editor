
React = require 'react'

store = require './store'

Editor = require './components/editor'

editor = Editor
  data: store.data
  onSave: (ast) ->
    console.log 'saving', ast

store.addChangeListener ->
  React.renderComponent editor, document.body

store.emit()
