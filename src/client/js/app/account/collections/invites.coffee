define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Invite = require('cs!app/account/models/invite')

  class Invites extends MongoCollection
    model: Invite