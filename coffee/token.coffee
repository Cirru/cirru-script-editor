
define (require, exports) ->

  {Unit} = require 'unit'
  letter = (char) ->
    "<span class='cirru-letter'>#{char}</span>"

  class Token extends Unit
    type: 'Token'

    makeElement: ->
      @el = $ '<div class="cirru-token">'
      @el.on 'click', (event) =>
        console.log 'click Token', @
        @focusEnd()
        @caret.moveCaret()
        event.stopPropagation()

    getEntryStart: ->
      entry: @caret.pointer.parent
      start: @caret.pointer.selfLocate()

    splice: (args...) ->
      @list.splice args...
      @render()

    render: ->
      @el.html (@list.map(letter).join '')

  {Token}