
React = require 'react'
$ = React.DOM

Sequence = require './sequence'
Complete = require './complete'

syntaxTree = require '../utils/syntax-tree'

module.exports = React.createClass
  displayName: 'Editor'

  getInitialState: ->
    buffer: ''
    ast: syntaxTree.label @props.data.ast

  changeBuffer: (buffer) ->
    @setState {buffer}

  componentDidMount: ->

  onSave: ->
    ast = syntaxTree.leach @state.ast
    @props.onSave ast

  updateToken: (token) ->
    ast = syntaxTree.updateToken @state.ast, token
    console.log 'setState'
    @setState {ast}

  render: ->
    $.div className: 'cirru-editor',
      Sequence
        ast: @state.ast, buffer: @state.buffer
        updateToken: @updateToken
      Complete ast: @state.ast, buffer: @state.buffer