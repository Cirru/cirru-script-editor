
= React $ require :react

= Editor $ React.createFactory $ require :./editor

= div $ React.createFactory :div

= cachedAst $ JSON.parse $ or
  localStorage.getItem :cirru-ast
  , :[]

= module.exports $ React.createClass $ object

  :displayName :container

  :getInitialState $ \ ()
    object
      :ast cachedAst
      :focus $ array

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast) (:focus focus)
    localStorage.setItem :cirru-ast $ JSON.stringify @state.ast

  :render $ \ ()
    div (object)
      Editor $ object
        :ast @state.ast
        :focus @state.focus
        :onChange @onChange
