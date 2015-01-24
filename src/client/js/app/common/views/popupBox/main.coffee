define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  eventBus = require('cs!app/common/eventBus')
  Marionette = require('marionette')
  ItemView = require('cs!app/common/marionette/itemView')

  MessageView = ItemView.extend({
    template: require('hbs!./messageView.hbs')

    templateHelpers: ->
      message: @options.message
  })

  ButtonSet = ItemView.extend({

    template: require('hbs!./buttonSet.hbs')

    templateHelpers: ->
      buttons: @options.buttons
      isPrimary: (context, options) ->
        if context.primary
          return options.fn(this)
        else
          return options.inverse(this)

    onCLick: (e) ->
      found = _.find @options.buttons, (button) ->
        # note: probably there is another way of finding button
        button.label is Marionette.$(e.currentTarget).text().trim()
      found.action(@options.view)
  })

  Dialog = Layout.extend

    template: require('hbs!./main.hbs')
    className: 'popup-box'

    initialize: (options) ->
      @title = options.title
      @view = options.view || new MessageView({
        message: options.message
      })
      @buttons = options.buttons

      @listenTo(@, 'render', @hideScroll)
      @listenTo(@, 'close', @displayScroll)
      @listenTo(@view, 'close', @close) if @view

    closeDialog: ->
      @close()

    templateHelpers: ->
      title: @title

    onRender: ->
      @renderComponents()

    hideScroll: ->
      Marionette.$(document.documentElement).addClass('no-scroll')

    displayScroll: ->
      Marionette.$(document.documentElement).removeClass('no-scroll')

    renderComponents: ->
      @content.show(@view) if @view
      if @buttons
        @footer.show new ButtonSet({
          view: @view
          buttons: @buttons
        })
      else
        @ui.$footer.hide()

  {
  context: (options) ->
    eventBus.trigger 'popup:show', new Dialog(options)
  }
