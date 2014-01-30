
define (require, exports) ->

  class Unit
    constructor: ->
      @list = []

    getLength: ->
      @list.length

    selfLocate: ->
      @parent.list.indexOf @

    push: (item) ->
      @list.push item

    splice: (args...) ->
      @list.splice args...

    drop: ->
      if @parent?
        @parent.splice @selfLocate(), 1
        delete @parent

    hasParent: ->
      @parent?

    isToken: ->
      @type is 'Token'

    isExp: ->
      @type is 'Exp'

    hasContent: ->
      @list.length > 0

    isEmpty: ->
      @list.length is 0

    focusEnd: (caret) ->
      caret.pointer = @
      caret.index = @getLength()

    focusStart: (caret) ->
      caret.pointer = @
      caret.index = 0

    focusBefore: (caret) ->
      if @hasParent()
        caret.index = @selfLocate()
        caret.pointer = @parent
        if @isEmpty()
          caret.pointer.splice caret.index, 1

    focusAfter: (caret) ->
      if @hasParent()
        if @isEmpty()
          caret.index = @selfLocate() 
          @parent.splice @selfLocate(), 1
          caret.pointer = @parent
        else if @hasContent()
          caret.index = @selfLocate() + 1
          caret.pointer = @parent

  {Unit}