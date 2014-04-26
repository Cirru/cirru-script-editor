
Cirru Editor
------

### Usage

Live demo: http://repo.tiye.me/cirru-editor

This editor if part of Cirru Project: http://cirru.org/

The module uses CommonJS and CSS `@import` for packaging.

```
npm install --save cirru-editor
```

```coffee
$ = require 'jquery'

{Editor} = require 'cirru-editor'
editor = new Editor

# put element into DOM manually
$('#entry').append editor.el

editor.val [[['x']]]
console.log editor.val()
```

Note that you have to `@import` CSS file manually.

```css
@import url('node_modules/cirru-editor/css/cirru-editor.css');
```

### Features

* Auto layout
* AutoComplete
* Navigate caret by clicking
* History for deleting

### Shortcuts:

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
| Ctrl z | Go Back |
| Ctrl y | Go Ahead |

### Screenshot

![](http://cirru.qiniudn.com/cirru-editor.png)

### License

MIT