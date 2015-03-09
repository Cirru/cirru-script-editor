
= React $ require :react/addons

require :./style/main.css

= Editor $ React.createFactory $ require :./components/editor

= keydownCode $ require :./util/keydown-code

= editor $ Editor

React.render editor document.body

window.addEventListener :keydown $ \ (event)
  if (is event.keyCode keydownCode.cancel)
    do
      event.preventDefault
