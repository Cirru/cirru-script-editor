
colors = require 'colors'
{inspect} = require 'util'
global.put = (x...) ->
  console.log  'debug:'.red
  console.log.call console, x
global.show = console.log 

to_array = (require './source2array').to_array
to_tree = (require './array2tree').to_tree
to_code = (require './tree2code').to_code
to_html = (require './array2html').to_html

fs = require 'fs'
source_file = 'source.cr'

compile = ->
  a = 'compile...'.red
  b = (new Date().getTime()).toString().yellow
  show a, b
  file = fs.readFileSync source_file, 'utf8'
  array = to_array file
  to_html array, 'array.html'
  tree = to_tree array
  code = to_code tree

op = interval: 400
do compile
fs.watchFile source_file, op, ->
  do compile