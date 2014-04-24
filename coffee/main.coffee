
{$} = require 'zepto-browserify'

{Editor} = require './editor'

window.editor = new Editor

$('#entry').append editor.el

try
  data = JSON.parse (localStorage.getItem 'editor')
  editor.val data

window.onbeforeunload = ->
  data = editor.val()
  localStorage.setItem 'editor', (JSON.stringify data)