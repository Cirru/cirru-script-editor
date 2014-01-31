
define (require, exports) ->

  {Unit} = require 'unit'
  {Token} = require 'token'
  $ = require 'jquery'

  class Exp extends Unit
    type: 'Exp'

    makeElement: ->
      @el = $ '<div class="cirru-exp">'
      @el.toggleClass 'all-token', @hasParent()
      @el.on 'click', (event) =>
        @focusEnd()
        @caret.moveCaret()
        event.stopPropagation()
        @caret.el.find('.cirru-input').focus()

    makeToken: ->
      new Token @, @caret

    makeExp: ->
      new Exp @, @caret

    getItem: (index) ->
      @list[index]

    getEntryStart: ->
      entry: @caret.pointer
      start: @caret.index

    splice: (args...) ->
      @list.splice args...
      [start, range, children...] = args
      index = 0
      while index < range
        @el.children().eq(start).remove()
        index += 1
      for item, index in children
        if start is 0
          @el.prepend item.el
        else
          @el.children().eq(start - 1 + index).after item.el
      @checkAllToken()

    checkAllToken: ->
      if @caret.pointer.isExp()
        if @list.length is 0
          allToken = yes
        else
          allToken = @list.every (item) ->
            item.isToken()

        @el.toggleClass 'all-token', allToken

    toJSON: ->
      readTree = (obj) =>
        if obj.isToken()
          obj.list.join ''
        else if obj.isExp()
          obj.list
          .map readTree
          .filter (item) ->
            item.length > 0

      readTree @caret.tree

    fromJSON: (tree) ->
      writeTree = (parent, item) =>
        if Array.isArray item
          newExp = new Exp parent, @caret
          parent.splice parent.getLength(), 0, newExp
          writeTree newExp, obj for obj in item
        else if typeof item is 'string'
          if item.length > 0
            newToken = new Token parent, @caret
            newToken.list = item.split ''
            newToken.render()
            parent.splice parent.getLength(), 0, newToken

      @caret.tree.list = []
      @caret.tree.el.innerHTML = ''
      tree.forEach (obj) =>
        writeTree @caret.tree, obj

  {Exp}