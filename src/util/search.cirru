
= generateSearch $ \ (text query info index)
  if (and (is text.length 0) (> query.length 0))
    do $ return $ object (:match false) (:start 0)

  if (is query.length 0)
    do $ return info

  = nextIndex $ + index 1

  if (is (. text 0) (. query 0))
    do
      if (< nextIndex info.start)
        do $ = info.start nextIndex
      return $ generateSearch (text.substr 1) (query.substr 1) info nextIndex

  generateSearch (text.substr 1) query info nextIndex

= exports.fuzzyStart $ \ (list query)
  = result $ list.map $ \ (text)
    = info $ object (:start 10) (:match true) (:text text)
    generateSearch text query info 0

  = result $ result.filter $ \ (item) item.match

  = result $ result.sort $ \ (a b)
    cond
      (< a.start b.start) -1
      (> a.start b.start) 1
      else 0

  return $ result.map $ \ (item) item.text
