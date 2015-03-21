
= React $ require :react

= astStore    $ require :../store/ast

= mixinListenTo $ require :../mixins/listen-to

= Expr $ React.createFactory $ require :./expr
= div $ React.createFactory :div

= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-editor
  :mixins $ array mixinListenTo

  :propTypes $ object
    :ast      T.array.isRequired
    :focus    T.array.isRequired
    :onChange T.func.isRequired

  :componentDidMount $ \ ()
    @listenTo astStore @setAst
    astStore.init @props.ast @props.focus

  :setAst $ \ ()
    @props.onChange (astStore.get) (astStore.getFocus)

  :onKeyDown $ \ (event)
    event.stopPropagation
    event.preventDefault

  :render $ \ ()
    div
      object (:className :cirru-editor) (:onKeyDown @onKeyDown)
      Expr
        object (:expr @props.ast) (:coord $ array)
          :focus @props.focus
          :level 0
          :inline false
