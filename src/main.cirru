
= React $ require :react/addons

= Editor $ React.createFactory $ require :./components/editor

= editor $ Editor

React.render editor document.body
