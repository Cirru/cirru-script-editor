
define (require, exports) ->

  show = (args...) -> console.log.apply console, args
  ls = localStorage

  $ = require '../lib/jquery/1.8.1/jquery.js'

  cirru = require('../script/cirru-editor.coffee')
  
  editor = cirru.editor $('#editor')

  list =
    if ls.list? then (JSON.parse ls.list).value
    else
      ls.list = JSON.stringify value: ['\t']
      ['\t']

  editor.val list
  editor.render()
  editor.reset_history list

  editor.update ->
    # show 'saved'
    ls.list = JSON.stringify value: editor.val()

  $('#editor').click()

  return