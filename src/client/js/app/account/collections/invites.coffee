define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Invite = require('cs!app/account/models/invite')

  class Invites extends MongoCollection
    model: Invite