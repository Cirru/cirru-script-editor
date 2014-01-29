
define (require, exports) ->
  $ = require 'jquery'
  {Editor} = require 'editor'

  editor = new Editor

  $('#entry').append editor.el