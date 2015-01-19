define (require) ->
  'use strict'

  md5 = require('md5')
  _ = require('underscore')

  return (email, options) ->
    options || options = {}
    options = _.defaults(options, {
      size: 32
    })
    'http://www.gravatar.com/avatar/' + md5(email.trim().toLowerCase()) + '?' + $.param(options)

