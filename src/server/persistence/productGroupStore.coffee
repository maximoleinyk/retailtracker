AbstractStore = inject('persistence/abstractStore')

class ProductGroupStore extends AbstractStore
  searchField: 'name'

module.exports = ProductGroupStore
