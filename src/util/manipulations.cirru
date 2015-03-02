
= updateHelper $ \ (ast coord text matched)
  if matched
    do $ if (> coord.length 0)
      do
        = head $ . coord 0
        = body $ coord.slice 1
        ast.map $ \ (item index)
          updateHelper item body text (is head index)
      do text
    do ast

= exports.updateToken $ \ (ast coord text)
  updateHelper ast coord text true
