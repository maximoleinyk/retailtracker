define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  ForgotPasswordSuccessPage = require('cs!./sent')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

    sendEmail: (e) ->
      e.preventDefault()

      @model.save().then =>
        @openPage(new ForgotPasswordSuccessPage)
