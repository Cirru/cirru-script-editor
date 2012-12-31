
{print} = require "util"
{spawn} = require "child_process"

echo = (child) ->
  child.stderr.pipe process.stderr
  child.stdout.pipe process.stdout

split = (str) -> str.split " "
d = __dirname

queue = [
  "stylus -o #{d}/page/ -w #{d}/page-src/"
  "stylus -o #{d}/src/ -w #{d}/source/"
  "jade -O #{d}/page/ -wP #{d}/page-src/"
  "coffee -o #{d}/src/ -wbc #{d}/source/"
  "coffee -o #{d}/page/ -wbc #{d}/page-src/"
  "doodle #{d}/page/ #{d}/src/"
]

task "dev", "watch and convert files", ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..])