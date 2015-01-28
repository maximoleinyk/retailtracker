define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  RegistrationSuccessPage = require('cs!./sent')
  i18n = require('cs!app/common/i18n')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

    register: (e) ->
      e.preventDefault()

      originButtonLabel = @ui.$registerButton.text()
      @ui.$registerButton.text(i18n.get('registrationLabelProcess')).attr('disabled', true)

      @model.register().then =>
        @openPage(new RegistrationSuccessPage)
      .catch =>
        @ui.$registerButton.text(originButtonLabel).removeAttr('disabled')

