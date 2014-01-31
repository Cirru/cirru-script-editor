
Cirru Editor
------

### Usage

Live demo: http://repo.tiye.me/cirru-editor

Currently is based on RequireJS and CSS `@import`.

```
bower install cirru-editor --save
```

Future plan maybe:

* wrap it as a Polymer element

A simple demo of usage:

```coffee
define (require, exports) ->
  $ = require 'jquery'
  {Editor} = require 'editor'

  # put element into DOM manually
  $('#entry').append editor.el

  editor.val [[['x']]]
  console.log editor.val()
```

### Features

* Auto layout
* AutoComplete

### Short cuts:

Debugged on OS X:

| Shortcut | Usage |
| --- | --- |
| Most Characters | Type in characters |
| Left | Go left by letter |
| Right | Go right by letter |
| Option Left | Go left by word |
| Option Right | Go right by word |
| Up | Go up by line or expression |
| Down | Go down by line or expression |
| Space | Seperate word |
| Shift Space | Insert blank |
| Tab | Choose next autocomplete candidate |
| Shift Tab | Choose previous autocomplete candidate |
| Backspace | Delete by one |
| Enter | Create expression |

### Screenshot

![](http://repo.tiye.me/cirru.org/pics/cirru-editor.jpg)

### License

MIT