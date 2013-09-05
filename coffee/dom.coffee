
exports.q = (query) -> document.querySelector query

exports.create = (name) ->
  name = 'div' unless name?
  document.createElement name