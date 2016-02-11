
var
  _ $ require :lodash

  history $ array
  pointer 0

  limit 30

= exports.init $ \ (ast)
  = history $ array ast

= exports.add $ \ (ast)
  var
    lookup $ history.slice pointer
    initial $ array ast
  = history $ initial.concat lookup
  = pointer 0

  if (>= history.length 30)
    do
      = history $ history.slice 0 30
  return

= exports.undo $ \ ()
  var
    next $ + pointer 1
    suppose $ . history next
  if (? suppose)
    do
      = pointer next
      return suppose
    do $ return $ . history pointer
  return

= exports.redo $ \ ()
  var
    next $ - pointer 1
    suppose $ . history next
  if (? suppose)
    do
      = pointer next
      return suppose
    do $ return $ . history pointer
  return
