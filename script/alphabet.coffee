
define (require, exports) ->
  alpha = 'qwertyuiopasdfghjklzxcvbnm'
  all = '`1234567890-=~!@#$%^&*()_+ '
  all+= alpha
  all+= alpha.toUpperCase()
  all+= '[]\\{}|;:"\',./<>?'

  exports.all = all.split ''
  
  return