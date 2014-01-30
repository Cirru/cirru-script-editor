
define (require, exports) ->

  search = (text, query) ->
    [head, body...] = query.split('')
    [textHead, textBody...] = text.split('')
    return false unless head is textHead
    xs = body.map (char) ->
      loop
        shift = textBody.shift()
        return true if shift is char
        break if textBody.length is 0
    console.log xs
    xs.every (x) -> x

  {search}