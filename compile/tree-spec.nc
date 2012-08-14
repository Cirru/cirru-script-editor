
string:
  " content (nested exps)

arr:
  # (item1) (item2) (item3)

json:
  & (k1 v1)
    k2 (& (k21 v21))

regex:
  // string

calculate:
  +  -  *  /  %
  += -= *= /= %=

compare:
  == > < >= <= !=
  is inst and or not

if:
  if (condition) ((then1) (then2) (then3)) (or1 or2 or3)

switch:
  switch
    (a) (f1 para)
    (b) (f2 para)
    else (f3 para)

run function:
  do f para1 para2

define function:
  fn (x y z) (do a) (do b) (do c)

while:
  while (cond) (do a) (do b) (do c)

for/in:
  each (obj) (item) (do a) (do b)

try/catch:
  try ((do a) (do b)) (err (do A) (do B))

assignment:
  = a b
  = (a b) (c d)

object:
  = a &
  = a.b c

attribute/method:
  . object name
  . object method (para) method ()

true/false:
  true yes right on
  false no wrong off

null/undefined:
  null undefined

continue/break/return:
  continue break return