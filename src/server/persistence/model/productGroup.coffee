mongoose = require('mongoose')
tree = require('mongoose-path-tree')

class ProductGroupSchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      description: String
      parentGroup: mongoose.Schema.Types.ObjectId

    @schema.plugin(tree, {
      pathSeparator: '.'
    })

    mongoose.mtModel('ProductGroup', @schema)

    return @

  get: (namespace) ->
    mongoose.mtModel(namespace('ProductGroup'))

module.exports = ProductGroupSchema
