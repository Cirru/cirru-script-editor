
dom = require './dom.coffee'
{editor} = require './editor.coffee'
utils = require './utils.coffee'

editor.init()
dom.q('#entry').appendChild editor.el
