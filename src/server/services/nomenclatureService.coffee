AbstractService = inject('services/abstractService')

class NomenclatureService extends AbstractService

  searchField: 'name'

  findAll: ->
    super.populate('uom productGroup')

  findById: ->
    super.populate('uom productGroup')

module.exports = NomenclatureService
