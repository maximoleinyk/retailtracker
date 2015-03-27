define (require) ->
  'use strict'

  Layout = require('app/common/marionette/layout')
  select = require('select')
  context = require('cs!app/common/context')
  PosCollection = require('cs!app/company/collections/pos')
  PosModel = require('cs!app/company/models/pos')
  _ = require('underscore')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./choose.hbs')
    className: 'page page-box'

    templateHelpers: ->
      hasStores: @options.stores.length

    onRender: ->
      @renderStoreSelect()
      @applyClassSelector()

    selectFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderStoreSelect: ->
      return if not @options.stores.length
      select @ui.$storeSelect,
        id: (object) ->
          return object._id
        ajax:
          url: '/store/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @selectFormatter
        formatResult: @selectFormatter
      @ui.$storeSelect.on('select2-selecting', _.bind(@fetchAllowedPos, this))

    fetchAllowedPos: (e) ->
      posCollection = new PosCollection
      @ui.$warning.addClass('hidden')
      posCollection.fetchAllowedPos(context.get('employee._id'), e.val)
      .then =>
        if posCollection.length
          @ui.$posGroup.removeClass('hidden')
          select @ui.$posSelect,
            data: posCollection.map (model) ->
              id: model.id
              text: model.get('name')
          @ui.$posSelect.on('select2-selecting', _.bind(@updateSubmitStatus, this))
        else
          @ui.$posGroup.addClass('hidden')
          @ui.$warning.removeClass('hidden').text(i18n.get('thereAreNoCashBoxesForThisStore'))
          @ui.$startSessionButton.attr('disabled', true)

    updateSubmitStatus: (e) ->
      @model = new PosModel({id: e.val})
      @ui.$startSessionButton.removeAttr('disabled')

    applyClassSelector: ->
      $('.app > .content-wrapper').addClass('box-like')

    startSession: ->
      @model.startSession(context.get('employee._id')).then =>
        @eventBus.trigger('module:load', 'pos', @model.id)
