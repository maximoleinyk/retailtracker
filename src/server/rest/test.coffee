HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
_ = require('underscore')

module.exports = (router) ->

  warehouseItems = [
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

  router.get '/warehouse/items', authFilter, (req, res) ->
    res.send(warehouseItems)

  router.get '/warehouse/items/search', authFilter, (req, res) ->
    res.jsonp _.filter warehouseItems, (item) ->
      item.productName.toLowerCase().indexOf(req.query.q) > -1