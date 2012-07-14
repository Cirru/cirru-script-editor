
exp = "(
  (set a (number 2))
  (set b (number 3))
  (plus a b)
  )
"

array = JSON.parse exp
  .replace(/\n/g, ' ')
  .replace(/\s+/g, ' ')
  .replace(/\(/g, ' [ ')
  .replace(/\)/g, ' ], ')
  .replace(/(\w+)\s/g, '"$1",')
  .replace(/\,]/g, ']')
  .replace(/],\s*]/g, ']]')
  .trim()[...-1]

console.dir array