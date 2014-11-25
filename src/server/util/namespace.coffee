module.exports =

  account: (req) ->
    (collection) ->
      req.headers.account + '.' + collection

  company: (req) ->
    (collection) ->
      req.headers.account + '.' + req.headers.company + '.' + collection

  accountWrapper: (account) ->
    @account({
      headers: {
        account: account
      }
    })

  companyWrapper: (account, company) ->
    @company({
      headers: {
        account: account
        company: company
      }
    })
