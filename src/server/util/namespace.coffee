module.exports =

  account: (req) ->
    (collection) ->
      req.headers.account + '.' + collection

  company: (req) ->
    (collection) ->
      req.headers.account + '.' + req.headers.company + '.' + collection

  accountWrapper: (account) ->
    (collection) ->
      account + '.' + collection
