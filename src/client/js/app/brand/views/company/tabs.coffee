define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  List = require('cs!./tabList')
  context = require('cs!app/common/context')
  Companies = require('cs!app/brand/collections/companies')
  $ = require('jquery')

  Layout.extend

    template: require('hbs!./tabs.hbs')
    className: 'company'

    onRender: ->
      if @options.tab is 'own'
        @openOwnTab()
      else if @options.tab is 'shared'
        @openSharedTab()
      else
        @openAllTab()
      @find('[data-tab="' + @options.tab + '"]').parent().addClass('active')

    openAllTab: ->
      @list.show new List({
        collection: @collection
      })

    openOwnTab: ->
      @list.show new List({
        collection: new Companies @collection.filter (model) ->
          context.get('owner.id') is model.get('owner._id')
      })

    openSharedTab: ->
      @list.show(new List({
        collection: new Companies @collection.filter (model) ->
          context.get('owner.id') isnt model.get('owner._id')
      }))

    openList: (e) ->
      e.preventDefault()
      @options.tab = $(e.currentTarget).data('tab')
      @render()
