
define (require, exports) ->

  class Unit
    constructor: ->
      @list = []

    indexOf: (item) ->
      @list.indexOf item

    getLength: ->
      @list.length

    selfLocate: ->
      @parent.indexOf @

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

    toParent: (caret) ->
      parent = @parent
      if @isEmpty() and @hasParent()
        @parent.splice @selfLocate(), 1
        delete @parent
        caret.index -= 1 if caret?
      parent

    focusEnd: (caret) ->
      caret.pointer = @
      caret.index = @getLength()

    focusStart: (caret) ->
      caret.pointer = @
      caret.index = 0

    focusBefore: (caret) ->
      if @hasParent()
        caret.index = @selfLocate()
        caret.pointer = @toParent()

    focusAfter: (caret) ->
      if @hasParent()
        if @isEmpty()
          @parent.splice @selfLocate(), 1
          caret.index = @selfLocate() + 1
          caret.pointer = @toParent()
          
  {Unit}