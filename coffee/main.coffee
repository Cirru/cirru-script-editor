
define (require, exports) ->
  $ = require 'jquery'
  {Editor} = require 'editor'

  window.editor = new Editor

  $('#entry').append editor.el

  # editor.val [[['x']]]