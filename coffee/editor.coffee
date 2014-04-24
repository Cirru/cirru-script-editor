

{$} = require 'zepto-browserify'
caretElement = $ '<div class="cirru-caret"></div>'

{Exp} = require './exp'
{Complete} = require './complete'
{EditorHistory} = require './history'

exports.Editor = class Editor
  constructor: ->
    @complete = new Complete @
    @history = new EditorHistory
    @makeElement()
    @bindEvents()
    @tree = new Exp null, @
    @setPointer @tree
    @setIndex 0
    @area.append @tree.el
    @moveCaret()

  makeElement: ->
    @el = $ '<div class="cirru-editor">'
    @area = $ '<pre class="cirru-area"/>'
    @input = $ '<input class="cirru-input"/>'

    @el.append @complete.el

    @el.append @area
    @el.append @input

  bindEvents: ->
    @el.on 'click', (event) =>
      @input.focus()
      # console.info 'focusing on editor!'
    @input.on 'blur', =>
      @el.removeClass 'cirru-focus'
    @input.on 'focus', =>
      @el.addClass 'cirru-focus'
    @input.on 'keypress', @handlePress.bind(@)
    @input.on 'keydown', @handeKeyDown.bind(@)

  handlePress: (event) ->
    char = String.fromCharCode event.charCode
    @insertChar char
    event.preventDefault()
    @moveCaret()
    $('#hint .press').text ('press:' + char)

  handeKeyDown: (event) ->
    signiture = []
    signiture.push 'alt' if event.altKey
    signiture.push 'ctrl' if event.ctrlKey
    signiture.push 'meta' if event.metaKey
    signiture.push 'shift' if event.shiftKey
    signiture.push event.keyCode
    identifier = signiture.join ' '
    @action identifier, event
    @moveCaret()
    $('#hint .down').text ('down:' + identifier)

  action: (name, event) ->
    switch name
      when '37'
        @actionLeft()
        event.preventDefault()
      when '39'
        @actionRight()
        event.preventDefault()
      when '38'
        @actionLineUp()
        event.preventDefault()
      when '40'
        @actionLineDown()
        event.preventDefault()
      when '13'
        @actionEnter()
        event.preventDefault()
      when '8'
        @actionDelete()
        event.preventDefault()
      when '9'
        @actionTab()
        event.preventDefault()
      when 'shift 9'
        @actionShiftTab()
        event.preventDefault()
      when '32'
        @actionBlank()
        event.preventDefault()
      when 'shift 32'
        @insertChar ' '
        event.preventDefault()
      when 'alt 37'
        @actionWordLeft()
        event.preventDefault()
      when 'alt 39'
        @actionWordRight()
        event.preventDefault()
      when 'alt 38'
        @actionUp()
        event.preventDefault()
      when 'alt 40'
        @actionDown()
        event.preventDefault()
      when 'ctrl 90'
        @actionBack()
        event.preventDefault()
      when 'ctrl 89'
        @actionForward()
        event.preventDefault()
      
    # console.info 'unhandled action:', name

  insertChar: (char) ->
    if @pointer.isToken()
      @pointer.splice @index, 0, char
      @index += 1
    else if @pointer.isExp()
      newToken = @pointer.makeToken()
      newToken.splice 0, 0, char
      @pointer.splice @index, 0, newToken
      @setPointer newToken
      @setIndex 1
    @complete.update()

  actionBlank: ->
    if @pointer.isExp()
      return
    else if @pointer.isToken()
      @setIndex @pointer.selfLocate() + 1
      @setPointer @pointer.parent
    @complete.update()

  actionUp: ->
    if @index > 0
      @setIndex 0
    else
      if @pointer.hasParent()
        @pointer.parent.focusStart()
    @complete.update()

  actionDown: ->
    if @index < @pointer.getLength()
      @setIndex @pointer.getLength()
    else
      if @pointer.hasParent()
        @pointer.parent.focusEnd()
    @complete.update()

  actionLeft: ->
    if @pointer.isToken()
      if @index > 0
        @index -= 1
      else
        @pointer.focusBefore()
    else if @pointer.isExp()
      if @index > 0
        lastToken = @pointer.getItem (@index - 1)
        @setPointer lastToken
        @setIndex lastToken.getLength()
      else
        @pointer.focusBefore()
    @complete.update()

  actionRight: ->
    if @pointer.isToken()
      if @index < @pointer.getLength()
        @index += 1
      else
        @pointer.focusAfter()
    else if @pointer.isExp()
      if @index < @pointer.getLength()
        nextToken = @pointer.getItem @index
        @setPointer nextToken
        @setIndex 0
      else
        @pointer.focusAfter()
    @complete.update()

  actionEnter: ->
    if @pointer.isToken()
      newExp = @pointer.parent.makeExp()
      entry = @pointer.selfLocate() + 1
      if @pointer.hasContent()
        @pointer.parent.splice entry, 0, newExp
      else if @pointer.isEmpty()
        @pointer.parent.splice entry, 1, newExp
      @setPointer newExp
      @setIndex 0
    else if @pointer.isExp()
      newExp = @pointer.makeExp()
      @pointer.splice @index, 0, newExp
      @setPointer newExp
      @setIndex 0
    @complete.update()

  actionDelete: ->
    if @pointer.isToken()
      if @index > 0
        @index -= 1
        @pointer.splice @index, 1
        if @pointer.isEmpty()
          @actionLeft()
      else
        @setIndex @pointer.selfLocate()
        @pointer.parent.splice @index, 1
        @setPointer @pointer.parent
    else if @pointer.isExp()
      if @index > 0
        @index -= 1
        @pointer.splice @index, 1
        @history.addRecord @val()
    @complete.update()

  actionWordLeft: ->
    if @pointer.isToken()
      @pointer.focusBefore()
    else if @pointer.isExp()
      if @index > 0
        @index -= 1
      else
        @pointer.focusBefore()
    @complete.update()

  actionWordRight: ->
    if @pointer.isToken()
      @pointer.focusAfter()
    else if @pointer.isExp()
      if @index < @pointer.getLength()
        @index += 1
      else
        @pointer.focusAfter()
    @complete.update()

  actionLineUp: ->
    {entry, start} = @pointer.getEntryStart()
    target = undefined
    while start > 0
      start -= 1
      item = entry.getItem start
      if item.isExp()
        target = item
        break

    if target?
      target.focusEnd()
    else
      entry.focusBefore()
    @complete.update()

  actionLineDown: ->
    {entry, start} = @pointer.getEntryStart()
    target = undefined
    length = entry.getLength()
    while start < length
      item = entry.getItem start
      if item.isExp()
        target = item
        break
      start += 1
    if target?
      target.focusStart()
    else
      entry.focusAfter()
    @complete.update()

  moveCaret: ->
    caret = @el.find('.cirru-caret').detach()
    caret = caretElement if caret.length is 0
    if @index is 0
      if @pointer.getLength() is 0
        @pointer.el.append caret
      else
        @pointer.el.children().eq(@index).before caret
    else
      @pointer.el.children().eq(@index - 1).after caret
    caret.get(0).scrollIntoViewIfNeeded()

  actionTab: ->
    return if @pointer.isExp()
    @complete.goNext()
    @swapToken()
    @pointer.render()
    @moveCaret()

  actionShiftTab: ->
    return if @pointer.isExp()
    @complete.goPrevious()
    @swapToken()
    @pointer.render()
    @moveCaret()

  swapToken: ->
    if @complete.isSelected()
      @pointer.list = @complete.getItem().split('')
      @setIndex @pointer.list.length
    else
      @pointer.list = @complete.cache
      @setIndex @pointer.list.length

  val: (tree) ->
    if tree?
      @tree = new Exp null, @
      @tree.fromJSON tree
      @area.empty().append @tree.el
      @setPointer @tree
      @setIndex @pointer.getLength()
      @moveCaret()
    else
      @tree.toJSON()

  setPointer: (obj) ->
    debugger unless obj?
    @pointer = obj

  setIndex: (index) ->
    @index = index

  actionBack: ->
    previousOne = @history.previousRecord()
    console.log 'previous', previousOne
    if previousOne?
      @val previousOne

  actionForward: ->
    nextOne = @history.nextRecord()
    console.log 'nextOne', nextOne
    if nextOne?
      @val nextOne