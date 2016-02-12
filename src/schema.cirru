
var
  Immutable $ require :immutable
  example $ require :./example.json

= exports.model $ Immutable.fromJS $ {}
  :tree example
  :focus $ [] 0 0
