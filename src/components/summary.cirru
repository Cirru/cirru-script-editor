
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
    :eventTrack React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {} :query :

  :filterLines $ \ ()
    ... @props.expr
      map $ \ (line index)
        Immutable.fromJS $ [] index
          cond
            is :string $ typeof (line.get 1)
            + (line.get 0) ": " (line.get 1)
            or (line.get 0) :
      filter $ \\ (line)
        <= 0
          ... line (get 1) (indexOf @state.query)

  :onQueryChange $ \ (event)
    event.stopPropagation
    @setState $ {} :query event.target.value

  :render $ \ ()
    div ({} :className :cirru-summary)
      div ({} :className :cirru-summary-box)
        ... (@filterLines) $ map $ \\ (line)
          var
            pointer $ line.get 0
            content $ line.get 1
            onClick $ \\ ()
              @props.onMovePointer pointer
              @props.dispatch :focus-to $ Immutable.fromJS $ [] pointer
              @props.eventTrack :move-pointer
          div
            {}
              :className $ cx :cirru-summary-line
                cond (is @props.pointer pointer) :is-selected
                cond (is content :) :is-empty
              :onClick onClick
              :key pointer
              :title content
            , content
      input $ {} (:className :cirru-query)
        :value @state.query
        :onChange @onQueryChange
        :placeholder ":filter..."
