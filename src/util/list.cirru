
= exports.removeOne $ \ (list one)
  = newList $ array
  = found false
  list.forEach $ \ (item)
    if found
      do $ newList.push item
      do $ if (is item one)
        do
          = found true
        do $ newList.push item
  return newList
