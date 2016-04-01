
require :../style/main.css

var
  React $ require :react
  ReactDOM $ require :react-dom

  keydownCode $ require :./util/keydown-code

  Container $ React.createFactory $ require :./components/container
  Immutable $ require :immutable
  installDevTools $ require :immutable-devtools

installDevTools Immutable

= window.isCirruLogOn true

ReactDOM.render (Container) (document.querySelector :#app)

window.addEventListener :keydown $ \ (event)
  if
    and
      is event.keyCode keydownCode.cancel
      is event.target document.body
    do
      console.log :blocked
      event.preventDefault
  return

if module.hot
  do $ module.hot.accept :./components/container $ \ ()
    = Container $ React.createFactory $ require :./components/container
    ReactDOM.render (Container) (document.querySelector :#app)
