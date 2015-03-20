AbstractStore = inject('persistence/abstractStore')

class UomStore extends AbstractStore
  searchField: 'shortName'

module.exports = UomStore
