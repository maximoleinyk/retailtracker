define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  class Activity extends MongoModel

    actions:
      'ACCOUNT_REGISTERED': (json) ->
        if context.isYou(json.user)
          json.action = i18n.get('youHaveRegisteredAccount')
        else
          json.action = i18n.get('userHasRegisteredAccount')
        return json

      'EMPLOYEE_INVITED_INTO_COMPANY': (json) ->
        json.action = i18n.get('userInvitedIntoCompany') + ' "<strong>' + json.company.name + '</strong>"'
        return json

      'EMPLOYEE_CONFIRMED_COMPANY_INVITE': (json) ->
        if context.isYou(json.user)
          json.action = i18n.get('youConfirmedInviteToCompany') + ' "<strong>' + json.company.name + '</strong>"'
        else
          json.action = i18n.get('userConfirmedInviteToCompany') + ' "<strong>' + json.company.name + '</strong>"'
        return json

      'EMPLOYEE_WAS_REMOVED_FROM_COMPANY': (json) ->
        json.action = i18n.get('userWasRemovedFromCompany') + ' "<strong>' + json.company.name + '</strong>"'
        return json

    parse: (json) ->
      json.user.id = json.user._id
      delete json.user._id
      formatter = @actions[json.action]
      if formatter then formatter(json) else json
