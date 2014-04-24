
exports.EditorHistory = class
  constructor: ->
    @_records = []
    @_pointer = -1

  addRecord: (data) ->
    data = JSON.stringify data
    if @_pointer < 0
      @_records.unshift data
    else
      @_records = @_records[@_pointer..]
      @_records.unshift data
      @_pointer = 0

  previousRecord: ->
    if @_pointer < (@_records.length - 1)
      @_pointer += 1
      ret = JSON.parse @_records[@_pointer]
      return ret

  nextRecord: ->
    if @_pointer > 0
      @_pointer -= 1
      ret = JSON.parse @_records[@_pointer]
      return ret
