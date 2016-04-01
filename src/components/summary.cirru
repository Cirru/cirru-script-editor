
var
  cx $ require :classnames
  React $ require :react
  Immutable $ require :immutable

  ({}~ div span input) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :cirru-summary

  :propTypes $ {}
    :expr $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :pointer React.PropTypes.number.isRequired
    :onMovePointer React.PropTypes.func.isRequired
    :dispatch React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {} :query :

  :filterLines $ \ ()
    ... @props.expr
      map $ \ (line)
        cond
          is :string $ typeof (line.get 1)
          + (line.get 0) ": " (line.get 1)
          or (line.get 0) :
      filter $ \\ (line)
        <= 0 (line.indexOf @state.query)
      map $ \ (line index)
        Immutable.fromJS $ [] line index

  :onQueryChange $ \ (event)
    event.stopPropagation
    @setState $ {} :query event.target.value

  :render $ \ ()
    div ({} :className :cirru-summary)
      input $ {} (:className :cirru-query)
        :value @state.query
        :onChange @onQueryChange
        :placeholder ":filter..."
      div ({} :className :cirru-summary-box)
        ... (@filterLines) $ map $ \\ (line)
          var
            pointer $ line.get 1
            onClick $ \\ ()
              @props.onMovePointer pointer
          div
            {}
              :className $ cx :cirru-summary-line
                cond (is @props.pointer pointer) :is-selected
                cond (is (line.get 0) :) :is-empty
              :onClick onClick
              :key pointer
            line.get 0
