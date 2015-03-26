
= exports.fuzzyStart $ \ (list query)
  = result $ list.map $ \ (text)
    = index $ text.indexOf query
    object
      :start index
      :match $ >= index 0
      :text text

  = result $ result.filter $ \ (item) item.match

  = result $ result.sort $ \ (a b)
    cond
      (< a.start b.start) -1
      (> a.start b.start) 1
      else 0

  return $ result.map $ \ (item) item.text
