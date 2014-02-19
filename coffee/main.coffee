
{$} = require 'zepto-browserify'

{Editor} = require './editor'

window.editor = new Editor

$('#entry').append editor.el

# editor.val [[['x']]]