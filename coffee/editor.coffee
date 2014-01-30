
define (require, exports) ->

  $ = require 'jquery'
  caretHtml = '<div class="cirru-caret"></div>'

  {Exp} = require 'exp'

  class Editor
    constructor: ->
      @makeElement()
      @bindEvents()
      @tree = new Exp
      @pointer = @tree.makeToken()
      @tree.push @pointer
      @index = 0
      @render()

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
          list.splice @index, 0, caretHtml if @pointer is obj
          inner = list.join ''
          "<div class='cirru-token'>#{inner}</div>"
        else if obj.isExp()
          list = obj.list.concat().map(convert)
          list.splice @index, 0, caretHtml if @pointer is obj
          inner = list.join ''
          "<div class='cirru-exp'>#{inner}</div>"
      console.debug @pointer, @index
      html = convert @tree
      @area.html html
      @el.find('.cirru-caret').get(0).scrollIntoView()

    handlePress: (event) ->
      char = String.fromCharCode event.charCode
      @insertChar char
      @render()
      event.preventDefault()

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
          @actionLineUp()
        when '40'
          @actionLineDown()
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
      if @index > 0
        @index = 0
      else
        if @pointer.hasParent()
          @pointer.parent.focusStart @

    actionDown: ->
      if @index < @pointer.getLength()
        @index = @pointer.getLength()
      else
        if @pointer.hasParent()
          @pointer.parent.focusEnd @

    actionLeft: ->
      if @pointer.isToken()
        if @index > 0
          @index -= 1
        else
          @pointer.focusBefore @
      else if @pointer.isExp()
        if @index > 0
          lastToken = @pointer.getItem (@index - 1)
          @pointer = lastToken
          @index = lastToken.getLength()
        else
          @pointer.focusBefore @

    actionRight: ->
      if @pointer.isToken()
        if @index < @pointer.getLength()
          @index += 1
        else
          @pointer.focusAfter @
      else if @pointer.isExp()
        if @index < @pointer.getLength()
          nextToken = @pointer.getItem @index
          @pointer = nextToken
          @index = 0
        else
          @pointer.focusAfter @

    actionEnter: ->
      if @pointer.isToken()
        newExp = @pointer.parent.makeExp()
        entry = @pointer.selfLocate() + 1
        if @pointer.hasContent()
          @pointer.parent.splice entry, 0, newExp
        else if @pointer.isEmpty()
          @pointer.parent.splice entry, 1, newExp
        @pointer = newExp
        @index = 0
      else if @pointer.isExp()
        newExp = @pointer.makeExp()
        @pointer.splice @index, 0, newExp
        @pointer = newExp
        @index = 0

    actionDelete: ->
      if @pointer.isToken()
        if @index > 0
          @index -= 1
          @pointer.splice @index, 1
        else
          @index = @pointer.selfLocate()
          @pointer.parent.splice @index, 1
          @pointer = @pointer.parent
      else if @pointer.isExp()
        if @index > 0
          @index -= 1
          @pointer.splice @index, 1

    actionWordLeft: ->
      if @pointer.isToken()
        @pointer.focusBefore @
      else if @pointer.isExp()
        if @index > 0
          @index -= 1
        else
          @pointer.focusBefore @

    actionWordRight: ->
      if @pointer.isToken()
        @pointer.focusAfter @
      else if @pointer.isExp()
        if @index < @pointer.getLength()
          @index += 1
        else
          @pointer.focusAfter @

    actionLineUp: ->
      {entry, start} = @pointer.getEntryStart @
      target = undefined
      while start > 0
        start -= 1
        item = entry.getItem start
        if item.isExp()
          target = item
          break

      if target?
        target.focusEnd @
      else
        entry.focusBefore @

    actionLineDown: ->
      {entry, start} = @pointer.getEntryStart @
      target = undefined
      length = entry.getLength()
      console.log 'start, length:', start, length
      while start < length
        item = entry.getItem start
        if item.isExp()
          target = item
          break
        start += 1
      if target?
        target.focusStart @
      else
        entry.focusAfter @

  {Editor}