
= _ $ require :lodash

= history $ array
= pointer 0

= limit 30

= exports.init $ \ (ast)
  = history $ array ast

= exports.add $ \ (ast)
  = lookup $ history.slice pointer
  = initial $ array ast
  = history $ initial.concat lookup
  = pointer 0

  if (>= history.length 30)
    do
      = history $ history.slice 0 30

= exports.undo $ \ ()
  = next $ + pointer 1
  = suppose $ . history next
  if (? suppose)
    do
      = pointer next
      return suppose
    do $ return $ . history pointer

= exports.redo $ \ ()
  = next $ - pointer 1
  = suppose $ . history next
  if (? suppose)
    do
      = pointer next
      return suppose
    do $ return $ . history pointer
