
require :../style/main.css

var
  React $ require :react
  ReactDOM $ require :react-dom

  keydownCode $ require :./util/keydown-code

  Container $ React.createFactory $ require :./components/container

= window.isCirruLogOn true

ReactDOM.render (Container) (document.querySelector :#app)

window.addEventListener :keydown $ \ (event)
  if (is event.keyCode keydownCode.cancel)
    do
      console.log :blocked
      event.preventDefault
  return

if module.hot
  do $ module.hot.accept :./components/container $ \ ()
    = Container $ React.createFactory $ require :./components/container
    ReactDOM.render (Container) (document.querySelector :#app)
