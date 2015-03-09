
Cirru Editor
----

built with React

### Keyboard

```cirru
tab
  token packNode
  expr packNode

shift tab
  token unpackExpr(parent)
  expr unpackExpr

enter
  token afterToken
  expr afterToken

shift enter
  token beforeToken
  expr beforeToken

command enter
  token afterToken
  expr prependToken
```

### Focus

```cirru
focus-to
focus-forward
focus-backward
focus-inside
focus-outside
```

### License

MIT
