Model = inject('persistence/model/activity')
moment = require('moment')

class ActivityStore

  constructor: ->
    @model = new Model

  fetch: (ns, callback) ->
#    @model.get(ns).find().populate('user').sort({dateTime: -1}).limit(10).exec(callback)
    callback(null, [
      {
        user:
          firstName: 'Василий'
          lastName: 'Зайцев'
        action: 'подтвердил приглашение в компанию "Ромашка"'
        dateTime: moment().toDate()
      },
      {
        user:
          firstName: 'Кирилл'
          lastName: 'Рабинович'
        action: 'подтвердил приглашение в компанию "ООО энергосталь"'
        dateTime: moment().add(2, 'hours').toDate()
      },
      {
        user:
          firstName: 'Роман'
          lastName: 'Шарапов'
        action: 'начал смену в магазине "Дом электроники"'
        dateTime: moment().add(1, 'days').toDate()
      }
    ])

module.exports = ActivityStore