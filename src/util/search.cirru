
= exports.fuzzyStart $ \ (list query)
  var result $ list.map $ \ (text)
    var index $ text.indexOf query
    object
      :start index
      :match $ >= index 0
      :text text

  = result $ result.filter $ \ (item) item.match

  = result $ result.sort $ \ (a b)
    case true
      (< a.start b.start) -1
      (> a.start b.start) 1
      else 0

  return $ result.map $ \ (item) item.text
