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

    return @

  get: (namespace) ->
    mongoose.model('ProductGroup', @schema, namespace('productgroups'))

module.exports = ProductGroupSchema