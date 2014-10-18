
React = require 'react'
$ = React.DOM

Sequence = require './sequence'
Complete = require './complete'

store = require './store'

module.exports = React.createClass
  displayName: 'Editor'

  getInitialState: ->
    ast: store.getAst()
    caret: store.getCaret()

  componentDidMount: ->
    store.emit = =>
      @setState ast: store.getAst()
      @props.onAstChange? store.exportData()

    store.importData @props.cirru

  render: ->
    $.div
      className: 'cirru-editor',
      Sequence
        ast: @state.ast
        caret: @state.caret
      Complete
        ast: @state.ast
        caret: @state.caret