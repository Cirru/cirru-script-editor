
define (require, exports) ->

  $ = require 'jquery'
  caret = '<div class="cirru-caret"></div>'

  class Unit
    constructor: ->
      @list = []

    indexOf: (item) ->
      @list.indexOf item

    selfLocate: ->
      @parent.indexOf @

    push: (item) ->
      @list.push item

    splice: (args...) ->
      @list.splice args...

    drop: ->
      if @parent?
        position = parent.locate @
        @parent.splice position, 1
        delete @parent

    hasParent: ->
      @parent?

    isToken: ->
      @type is 'Token'

    isExp: ->
      @type is 'Exp'

  class Token extends Unit
    type: 'Token'
    constructor: (@parent) ->
      super()

    hasContent: ->
      @list.length > 0

  class Exp extends Unit
    type: 'Exp'
    constructor: (@parent) ->
      super()

    makeToken: ->
      new Token @

  class Editor
    constructor: ->
      @makeElement()
      @bindEvents()
      @tree = new Exp
      @pointer = @tree.makeToken()
      @tree.push @pointer
      @index = 0

    makeElement: ->
      @el = $ '<div>'
      @el.attr 'class', 'cirru-editor'
      @area = $ '<pre class="cirru-area"/>'
      @input = $ '<input class="cirru-input"/>'

      @el.append @area
      @el.append @input

    bindEvents: ->
      @el.on 'click', =>
        @input.focus()
        console.info 'focusing on editor!'
      @input.on 'keypress', @handlePress.bind(@)
      @input.on 'keydown', @handeKeyDown.bind(@)

    render: ->
      convert = (obj) =>
        if obj.isToken()
          list = obj.list.concat()
          list.splice @index, 0, caret if @pointer is obj
          inner = list.join ''
          "<div class='cirru-token'>#{inner}</div>"
        else if obj.isExp()
          list = obj.list.concat().map(convert)
          list.splice @index, 0, caret if @pointer is obj
          inner = list.join ''
          "<div class='cirru-exp'>#{inner}</div>"
      console.debug @tree
      html = convert @tree
      @area.html html

    handlePress: (event) ->
      char = String.fromCharCode event.charCode
      @insertChar char
      @render()

    handeKeyDown: (event) ->
      signiture = []
      signiture.push 'alt' if event.altKey
      signiture.push 'ctrl' if event.ctrlKey
      signiture.push 'meta' if event.metaKey
      signiture.push 'shift' if event.shiftKey
      signiture.push event.keyCode
      identifier = signiture.join ' '
      @action identifier, event
      @render()

    action: (name, event) ->
      switch name
        when '37'
          @actionLeft()
        when '39'
          @actionRight()
        when '38'
          @actionUp()
        when '40'
          @actionDown()
        when '13'
          @actionEnter()
          event.preventDefault()
        when '8'
          @actionDelete()
          event.preventDefault()
        when '9'
          @insertChar ' '
          event.preventDefault()
        when '32'
          @actionBlank()
          event.preventDefault()
        
      console.info 'unhandled action:', name

    insertChar: (char) ->
      if @pointer.isToken()
        @pointer.splice @index, 0, char
        @index += 1
      else if @pointer.isExp()
        newToken = @pointer.makeToken()
        newToken.push char
        @pointer.splice @index, 0, newToken
        @pointer = newToken
        @index = 1

    actionBlank: ->
      if @pointer.isExp()
        return
      else if @pointer.isToken()
        @index = @pointer.selfLocate() + 1
        @pointer = @pointer.parent

    actionUp: ->

    actionDown: ->

    actionLeft: ->

    actionRight: ->

    removeChar: ->

    actionEnter: ->

    actionDelete: ->

  {Editor}