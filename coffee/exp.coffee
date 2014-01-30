
define (require, exports) ->

  {Unit} = require 'unit'
  {Token} = require 'token'
  $ = require 'jquery'

  class Exp extends Unit
    type: 'Exp'

    makeElement: ->
      @el = $ '<div class="cirru-exp">'
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
      for item in children.reverse()
        if @el.children().length is 0
          @el.append item.el
        else
          @el.children().eq(start - 1).after item.el

  {Exp}