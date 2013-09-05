
dom = require './dom.coffee'
{editor} = require './editor.coffee'
utils = require './utils.coffee'

utils.delay 200, ->
  editor.init()
  dom.q('#entry').appendChild editor.el
