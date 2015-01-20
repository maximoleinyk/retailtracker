Model = inject('persistence/model/counterparty')
AbstractStore = inject('persistence/abstractStore')

class CounterpartyStore extends AbstractStore

  constructor: ->
    @model = new Model

module.exports = CounterpartyStore
