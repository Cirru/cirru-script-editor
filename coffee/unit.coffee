
define (require, exports) ->

  class Unit
    constructor: (@parent, @caret) ->
      @list = []
      @makeElement()

    getLength: ->
      @list.length

    selfLocate: ->
      @parent.list.indexOf @

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

    focusEnd: ->
      @caret.setPointer @
      @caret.index = @getLength()

    focusStart: ->
      @caret.setPointer @
      @caret.index = 0

    focusBefore: ->
      if @hasParent()
        @caret.index = @selfLocate()
        @caret.setPointer @parent
        if @isEmpty()
          @caret.pointer.splice @caret.index, 1

    focusAfter: ->
      if @hasParent()
        if @isEmpty()
          @caret.index = @selfLocate() 
          @parent.splice @selfLocate(), 1
          @caret.setPointer @parent
        else if @hasContent()
          @caret.index = @selfLocate() + 1
          @caret.setPointer @parent

  {Unit}