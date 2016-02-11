
require :../style/main.css

var
  React $ require :react
  ReactDOM $ require :react-dom

  keydownCode $ require :./util/keydown-code

  Container $ React.createFactory $ require :./components/container

  editor $ Container

= window.isCirruLogOn true

ReactDOM.render editor (document.querySelector :#app)

window.addEventListener :keydown $ \ (event)
  if (is event.keyCode keydownCode.cancel)
    do
      console.log :blocked
      event.preventDefault
  return
