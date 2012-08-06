
{inspect} = require 'util'
global.show1 = (x...) ->
  y = x.map (z) -> inspect x, false, null
  console.log.call console, y
global.show = console.log

to_array = (require './source2array').to_array
to_tree = (require './array2tree').to_tree
to_code = (require './tree2code').to_code
to_html = (require './array2html').to_html

fs = require 'fs'
source_file = 'source.cr'
colors = require 'colors'

compile = ->
  show 'compile...'.red
  show (new Date().getTime()).toString().blue
  file = fs.readFileSync source_file
  array = to_array file
  to_html array, 'array.html'
  tree = to_tree array
  code = to_code tree

do compile
fs.watchFile source_file, ->
  do compile