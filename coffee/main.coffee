
React = require 'react'

body = document.body

store = require './store'

AppComponent = require './components/app'

render = ->
  React.renderComponent AppComponent(ast: store.getAST()), body

store.addChangeListener render

render()