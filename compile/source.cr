
+ 1 2 (+ 1 2)

str a d g

json (a 1)
  b (json (a 4))

= a 1

= f
  fn (a b)
    return (+ a b)

= obj
  json
    a 1
    b
      list 1 2 3 (str string\ with \(\))
    c (do f 1 2)

each obj k v
  flow
    . console (log k v)

switch a
  1
    flow (. console (log 1))
  2
    flow (. console (log 2))
  flow (+ 1 2)

= put
  fn (x)
    . console (log x)

if (> 2 1)
  do put true
  do put false

= c 0
while (< c 9)
  flow
    += c 1
    do put (str counting (bare c))

and (> 2 3) (> 3 2 1) true

flow
  do put 1
  do put 2
  do put 3