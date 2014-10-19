define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Invite = require('cs!app/brand/models/invite')
  request = require('util/request')

  class Invites extends MongoCollection
    model: Invite