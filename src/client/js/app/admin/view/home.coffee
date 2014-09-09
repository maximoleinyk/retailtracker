define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('grid')
  moment = require('moment')
  Backbone = require('backbone')

  Marionette.ItemView.extend
    template: require('hbs!./home')

    ui:
      $container: '[data-hook="grid-wrapper"]'

    onShow: ->
      collection = new Backbone.Collection();
      collection.add(new Backbone.Model({
        id: 1
        name: 'Patrick'
        age: 23
        born: new Date()
      }))
      collection.add(new Backbone.Model({
        id: 2
        name: 'Sam'
        age: 39
        born: new Date()
      }))
      collection.add(new Backbone.Model({
        id: 3
        name: 'Angela'
        age: 28
        born: new Date()
      }))

      grid = new Grid({
        el: @ui.$container,
        collection: collection,
        columns:
          id:
            title: 'Идентификатор'
          name:
            title: 'Имя'
          age:
            title: 'Возраст'
          born:
            title: 'Родился'
            format: (value) ->
              moment(value).format('DDMMYY')
      })
      grid.render()
