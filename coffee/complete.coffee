
define (require, exports) ->

  $ = require 'jquery'
  {search} = require 'search'

  class Complete
    constructor: (@editor) ->
      @makeElement()
      @index = -1
      @tokens = []

    makeElement: ->
      @el = $ '<div class="cirru-complete"></div>'

    updateTokens: ->
      list = []
      readExp = (obj) =>
        obj.list.map (item) =>
          if item.type is 'Token'
            list.push item unless @editor.pointer is item
          else if item.type is 'Exp'
            readExp item
      readExp @editor.tree
      @tokens = []
      list.map (item) =>
        word = item.list.join('')
        unless word in @tokens
          if search word, @editor.pointer.list.join('')
            @tokens.push word
      @tokens

    update: ->
      @index = -1
      @render()

    render: ->
      html = @tokens
      .map (item, index) =>
        console.log index, @index
        if index is @index
          "<div class='cirru-item cirru-active'>#{item}</div>"
        else
          "<div class='cirru-item'>#{item}</div>"
      .join ''
      @el.html html

    getItem: ->
      @tokens[@index]

    goNext: ->
      if @index is (@tokens.length - 1)
        @index = -1
      else
        @index += 1

    goPrevious: ->
      if @index > 0
        @index -= 1
      else
        @index = (@tokens.length - 1)

    isSelected: ->
      @index >= 0

  {Complete} 