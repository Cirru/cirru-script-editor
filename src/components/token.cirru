
= React $ require :react/addons
= _ $ require :lodash
= cx $ require :classnames

= astStore    $ require :../store/ast

= search $ require :../util/search
= list $ require :../util/list

= astActions $ require :../actions/ast

= detect $ require :../util/detect
= keydownCode $ require :../util/keydown-code

= Suggest $ React.createFactory $ require :./suggest
= span $ React.createFactory :span
= input $ React.createFactory :input

= mixinListenTo $ require :../mixins/listen-to

= iconUrl $ require ":../../images/cirru-32x32.png"

= T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :cirru-token

  :getInitialState $ \ () $ object
    :disableSuggest true
    :select 0
    :isDrag false
    :isDrop false

  :propTypes $ object
    :token T.string.isRequired
    :coord T.array.isRequired
    :focus T.array.isRequired

  :componentDidMount $ \ ()
    @setFocus

  :componentDidUpdate $ \ ()
    @setFocus

  :shouldComponentUpdate $ \ (props state)
    if (isnt props.token @props.token)
      do $ return true
    if (not $ _.isEqual props.focus @props.focus)
      do
        if (_.isEqual props.focus @props.coord)
          do $ return true
        if (_.isEqual props.focus props.coord)
          do $ return true
    if (not $ _.isEqual state @state)
      do $ return true
    return false

  :setFocus $ \ ()
    if (_.isEqual @props.coord @props.focus)
      do
        = inputEl $ @refs.input.getDOMNode
        if (is document.activeElement inputEl)
          do $ return
        inputEl.focus
        = inputEl.selectionStart inputEl.value.length
        = inputEl.selectionEnd inputEl.value.length

  :getTokens $ \ ()
    = tokens $ _.flattenDeep $ astStore.get
    = tokens $ tokens.filter $ \ (item)
      > item.length 2
    = tokens $ list.removeOne tokens @props.token
    = uniqueTokens $ _.unique tokens
    search.fuzzyStart uniqueTokens @props.token

  :inSuggest $ \ ()
    if @state.disableSuggest
      do $ return false

    = tokens (@getTokens)
    if (is tokens.length 0)
      do $ return false

    return true

  :getCurrentGuess $ \ ()
    = tokens (@getTokens)
    . tokens @state.select

  :selectPrev $ \ ()
    = tokens $ @getTokens
    if (> @state.select 0)
      do $ @setState $ object $ :select $ - @state.select 1
      do $ @setState $ object $ :select $ - tokens.length 1

  :selectNext $ \ ()
    = tokens $ @getTokens
    if (>= @state.select (- tokens.length 1))
      do $ @setState $ object $ :select 0
      do $ @setState $ object $ :select $ + @state.select 1

  :isCaretAhead $ \ ()
    = inputEl $ @refs.input.getDOMNode
    is inputEl.selectionStart 0

  :isCaretBehind $ \ ()
    = inputEl $ @refs.input.getDOMNode
    is inputEl.selectionEnd inputEl.value.length

  :onChange $ \ (event)
    = text event.target.value
    astActions.updateToken @props.coord text
    @setState $ object
      :disableSuggest false
      :select 0

  :onSuggest $ \ (text)
    astActions.updateToken @props.coord text
    @setState $ object
      :disableSuggest true

  :onClick $ \ (event)
    astActions.focusTo @props.coord

  :onBlur $ \ (event)
    @setState $ object
      :disableSuggest true

  :onRootClick $ \ (event)
    event.stopPropagation

  :onKeyDown $ \ (event)
    event.stopPropagation
    = keyCode event.keyCode
    switch keyCode
      keydownCode.esc
        @setState $ object (:disableSuggest true)
        return undefined
      keydownCode.enter
        = tokens (@getTokens)
        if (@inSuggest)
          do
            @onSuggest $ @getCurrentGuess
            @setState $ object
              :disableSuggest true
          do
            if event.shiftKey
              do $ astActions.beforeToken @props.coord
              do $ astActions.afterToken @props.coord
            @setState $ object
              :disableSuggest true
      keydownCode.tab
        event.preventDefault
        if event.shiftKey
          do $ astActions.unpackExpr $ @props.coord.slice 0 -1
          do $ astActions.packNode @props.coord
      keydownCode.up
        if (@inSuggest)
          do
            event.preventDefault
            @selectPrev
          do $ if (@isCaretAhead)
            do $ astActions.goUp @props.coord
      keydownCode.down
        if (@inSuggest)
          do
            event.preventDefault
            @selectNext
          do $ if (@isCaretBehind)
            do $ astActions.goDown @props.coord
      keydownCode.cancel
        if (is @props.token :)
          astActions.removeNode @props.coord
          event.stopPropagation
          event.preventDefault
      keydownCode.left
        if (@isCaretAhead)
          do $ astActions.goLeft @props.coord
      keydownCode.right
        if (@isCaretBehind)
          do $ astActions.goRight @props.coord
      keydownCode.z
        if (or event.metaKey event.ctrlKey)
          do
            event.preventDefault
            if event.shiftKey
              do $ astActions.redo
              do $ astActions.undo

  :onDragOver $ \ (event)
    event.preventDefault

  :onDragStart $ \ (event)
    = img $ document.createElement :img
    = img.src iconUrl
    event.dataTransfer.setDragImage img 16 16
    event.stopPropagation
    astActions.focusTo @props.coord
    @setState $ object (:isDrag true)

  :onDragEnd $ \ (event)
    @setState $ object (:isDrag false)

  :onDragEnter $ \ (event)
    @setState $ object (:isDrop true)

  :onDragLeave $ \ (event)
    @setState $ object (:isDrop false)

  :onDrop $ \ (event)
    event.stopPropagation
    @setState $ object (:isDrop false)
    astActions.dropTo @props.coord

  :render $ \ ()
    = width $ detect.textWidth @props.token :14px :Menlo
    = style $ object
      :width $ ++: (+ width 8) :px
    = tokens (@getTokens)
    = className $ cx $ object
      :cirru-token true
      :is-fuzzy $ or (is @props.token :) (? (@props.token.match /\s))
      :is-drag @state.isDrag
      :is-drop @state.isDrop

    span
      object (:className className) (:draggable true) (:onClick @onRootClick)
        :tabIndex 0
        :onDragOver @onDragOver
        :onDragStart @onDragStart
        :onDragEnd @onDragEnd
        :onDragEnter @onDragEnter
        :onDragLeave @onDragLeave
        :onDrop @onDrop
      input
        object (:value @props.token) (:style style) (:ref :input)
          :onBlur @onBlur
          :onChange @onChange
          :onKeyDown @onKeyDown
          :onClick @onClick
      if (and (_.isEqual @props.focus @props.coord) (not @state.disableSuggest))
        Suggest $ object
          :text @props.token
          :onSuggest @onSuggest
          :tokens tokens
          :select @state.select
