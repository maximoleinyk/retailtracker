Model = inject('persistence/model/activity')
moment = require('moment')

class ActivityStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    Activity = @model.get(ns)
    activity = new Activity(data)
    activity.save(callback)

  fetch: (ns, callback) ->
    @model.get(ns).find().populate('user').sort({dateTime: -1}).limit(10).exec(callback)
#    callback(null, [
#      {
#        user:
#          firstName: 'Василий'
#          lastName: 'Зайцев'
#        action: 'подтвердил приглашение в компанию "ЭкоБэнд"'
#        dateTime: moment().toDate()
#      },
#      {
#        user:
#          firstName: 'Кирилл'
#          lastName: 'Рабинович'
#        action: 'подтвердил приглашение в компанию "ООО энергосталь"'
#        dateTime: moment().subtract(2, 'hours').toDate()
#      },
#      {
#        user:
#          firstName: 'Роман'
#          lastName: 'Шарапов'
#        action: 'был удален из списка сотрудников компании "Дом электроники"'
#        dateTime: moment().subtract(4, 'days').toDate()
#      },
#      {
#        user:
#          firstName: 'Сергей'
#          lastName: 'Нишанов'
#        action: 'подтвердил приглашение в компанию "ЭкоБэнд"'
#        dateTime: moment().subtract(11, 'days').toDate()
#      }
#    ])

module.exports = ActivityStore