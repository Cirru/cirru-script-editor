
define (require, exports) ->

  show = (args...) -> console.log.apply console, args

  cirru = require('../src/cirru-editor.js')
  
  editor = cirru.editor 'editor'

  return