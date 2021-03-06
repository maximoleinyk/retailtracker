define (require) ->
  'use strict'

  require('jquery')
  require('underscore')
  require('backbone')
  require('marionette')
  require('cs!app/common/i18n')
  require('cs!app/common/context')
  require('cs!app/common/avatar')
  require('cs!app/common/collection')
  require('cs!app/common/model')
  require('cs!app/common/controller')
  require('cs!app/common/i18n')
  require('cs!app/common/io')
  require('cs!app/common/router')
  require('cs!app/common/uuid')
  require('app/common/dataBinding')
  require('app/common/eventBus')
  require('app/common/http')
  require('app/common/request')
  require('app/common/select')
  require('app/common/validators')
  require('cs!app/common/marionette/compositeView')
  require('cs!app/common/marionette/itemView')
  require('cs!app/common/marionette/layout')
  require('app/common/grid/main')
  require('app/common/marionette/mixin')
  require('app/common/helpers')
  require('cs!app/common/moduleLoader')
