
define (require, exports) ->

  show = (args...) -> console.log.apply console, args

  cirru = require('../script/cirru-editor.coffee')
  
  editor = cirru.editor 'editor'

  return