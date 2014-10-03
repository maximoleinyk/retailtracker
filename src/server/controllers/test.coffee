HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
_ = require('underscore')

module.exports = (router) ->
  productItems = [
    {
      id: 1
      productName: 'Apple watch'
      amount: 2
      price: 300.00
    }
    {
      id: 2
      productName: 'Apple USB cable charger for iPhone'
      amount: 5
      price: 20.0
    }
    {
      id: 3
      productName: 'Nexus 5'
      amount: 3,
      price: 400.0
    }
  ]

  router.get '/product/items', authFilter, (req, res) ->
    res.send([
      {
        product: 1
        productName: 'Apple watch'
        count: 1
        price: 300.0
      }
      {
        product: 3
        productName: 'Nexus 5'
        count: 1
        price: 400.0
      }
    ])

  router.get '/products/search', authFilter, (req, res) ->
    res.jsonp _.filter productItems, (item) ->
      query = if req.query.q then req.query.q.toLowerCase() else ''
      item.productName.toLowerCase().indexOf(query) > -1
