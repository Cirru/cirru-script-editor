
= removeOneHelper $ \ (before current after one)
  if (is current one)
    do $ before.concat after
    do $ if (is after.length 0)
      do $ before.concat current
      do
        removeOneHelper (before.concat current) (. after 0) (after.slice 1) one

= exports.removeOne $ \ (list one)
  if (is list.length 0)
    do $ return list

  removeOneHelper (array) (. list 0) (list.slice 1) one
