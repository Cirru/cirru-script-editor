
= React $ require :react/addons

require :./style/main.css

= Container $ React.createFactory $ require :./components/container

= keydownCode $ require :./util/keydown-code

= editor $ Container
= window.isCirruLogOn true

React.render editor document.body

window.addEventListener :keydown $ \ (event)
  if (is event.keyCode keydownCode.cancel)
    do
      console.log :blocked
      event.preventDefault
