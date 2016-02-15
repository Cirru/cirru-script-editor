
var
  Immutable $ require :immutable
  example $ require :./example.json

= exports.model $ Immutable.fromJS $ {}
  :tree $ []
  :focus $ [] 0 0
