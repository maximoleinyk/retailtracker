define (require) ->
  'use strict'

  CompositeView = require('cs!app/common/marionette/compositeView')
  ItemView = require('cs!./item')
  i18n = require('cs!app/common/i18n')
  Handlebars = require('handlebars')

  CompositeView.extend

    template: require('hbs!./tabList.hbs')
    itemView: ItemView
    tagName:'ul'
    className: 'list'
    emptyView: ItemView.extend({ template: Handlebars.compile('<p class="text-center">{{i18n.emptyList}}</p>')})
