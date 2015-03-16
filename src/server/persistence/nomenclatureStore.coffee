AbstractStore = inject('persistence/abstractStore')

class NomenclatureStore extends AbstractStore

  searchField: 'name'

module.exports = NomenclatureStore
