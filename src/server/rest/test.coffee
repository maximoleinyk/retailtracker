HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

module.exports = (router) ->

  router.get '/products/search', authFilter, (req, res) ->
    res.jsonp([
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
    ])