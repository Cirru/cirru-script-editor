
require("calabash").do ("task",
  "pkill -f doodle",
  "coffee -o src/ -bwcm coffee/",
  "doodle src/ index.html log:yes"
)