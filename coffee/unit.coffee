
exports.Unit = class Unit
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
    oldPointer = @caret.pointer
    @caret.setPointer @
    @caret.setIndex @getLength()
    oldPointer.selfRemoveIfNeeded()

  focusStart: ->
    @caret.setPointer @
    @caret.setIndex 0

  focusBefore: ->
    if @hasParent()
      @caret.setIndex @selfLocate()
      @caret.setPointer @parent
      if @isEmpty()
        @caret.pointer.splice @caret.index, 1

  focusAfter: ->
    if @hasParent()
      if @isEmpty()
        @caret.setIndex @selfLocate() 
        @parent.splice @selfLocate(), 1
        @caret.setPointer @parent
      else if @hasContent()
        @caret.setIndex @selfLocate() + 1
        @caret.setPointer @parent

  selfRemoveIfNeeded: ->
    if @isEmpty()
      if @caret.pointer isnt @
        if @hasParent()
          @parent.splice @selfLocate(), 1
          if @caret.pointer is @parent
            @caret.index -= 1
          @parent.selfRemoveIfNeeded()
