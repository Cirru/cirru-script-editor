
= React $ require :react/addons

require :./style/main.css

= Editor $ React.createFactory $ require :./components/editor

= editor $ Editor

React.render editor document.body
