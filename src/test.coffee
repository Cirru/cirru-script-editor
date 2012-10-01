
show = (args...) -> console.log.apply console, args

ls = localStorage

$ ->

  cirru = require('./cirru-editor.js')
  
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