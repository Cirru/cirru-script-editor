
require("calabash").do "task",
  "pkill -f doodle"
  "coffee -o src/ -bwc coffee/"
  'watchify -o build/build.js src/main.js -v'
  "doodle build/ index.html log:yes"