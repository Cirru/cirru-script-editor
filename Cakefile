
{print} = require "util"
{spawn} = require "child_process"

echo = (child) ->
  child.stderr.pipe process.stderr
  child.stdout.pipe process.stdout

split = (str) -> str.split " "
d = __dirname

queue = [
  "stylus -o #{d}/examples/ -w #{d}/page/"
  "stylus -o #{d}/src/ -w #{d}/script/"
  "jade -O #{d}/examples/ -wP #{d}/page/"
  "coffee -o #{d}/src/ -wbc #{d}/script/"
  "coffee -o #{d}/examples/ -wbc #{d}/page/"
  "doodle #{d}/examples/ #{d}/src/"
]

task "dev", "watch and convert files", ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..])