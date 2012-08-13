
fs = require 'fs'

wrap = (x) ->
  if typeof x is 'string'
    "<span>#{x.replace /\s/g, '&nbsp;'}</span>"
  else "<div>#{x.map(wrap).join ''}</div>"

exports.to_html = (arr, file) ->
  string = '<link rel="stylesheet" href="s.css">' 
  string += wrap arr
  fs.writeFile file, string