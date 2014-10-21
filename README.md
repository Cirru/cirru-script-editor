
Cirru Editor
------

### Usage

Live demo: http://repo.cirru.org/editor

This projecy is part of Cirru Project: http://cirru.org/

This module is a React Component:

```
npm i -s cirru-editor
```

```coffee
React = require 'react'
Editor = require 'cirru-editor' # need to change in React 0.12

editor = Editor
  cirru: ['cirru code']
  onAstChange: (cirru) ->
    ast = cirru

React.renderComponent editor, document.body
```

The module uses CommonJS and CSS `@import` for packaging.
Note that you have to `@import` CSS file manually.

```css
@import url('node_modules/cirru-editor/build/css/editor.css');
```

### Features

* Auto layout
* AutoComplete
* Navigate caret by clicking
* Drag and drop

### Shortcuts:

The app is developed in Chrome in OS X, caret has two modes:

* Sequence Caret (a caret alone with point at top)

| Shortcut | Usage |
| --- | --- |
| Left | Move left by one token |
| Right | Move right by one token |
| Up | Select precious suggestion |
| Down | Select next suggestion |
| Backspace | delete by token or sequence |
| Enter | Choose suggestion |

* Token Caret (in contentEditable token)

| Shortcut | Usage |
| --- | --- |
| Left | move in text |
| Right | move in text |
| Space | space in text |
| Tab | move caret out |
| Backspace | delete in text |
| Enter | Create expression |

### License

MIT