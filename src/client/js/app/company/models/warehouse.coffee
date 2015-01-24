define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  class Warehouse extends Model

    urlRoot: '/warehouse'

    defaults: ->
      name: i18n.get('newWarehouse')
      assignee: context.get('employee')

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    destroy: ->
      destroy = new Promise (resolve, reject) =>
        Model::destroy.apply(this).done(resolve).fail(reject)
      destroy.then (result) =>
        @set @parse(result)
        @commit()
