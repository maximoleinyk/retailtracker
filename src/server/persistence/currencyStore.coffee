AbstractStore = inject('persistence/abstractStore')

class CurrencyStore extends AbstractStore
  searchField: 'name'

module.exports = CurrencyStore
