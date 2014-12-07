define (require) ->
  'use strict'

  _ = require('underscore')

  regexp = /\{(\d+)\}/
  replace = (key, value, varargs...) ->
    if (regexp.test(value))
      while (match = regexp.exec(value))
        value = value.replace(match[0], varargs[+match[1]])
    return value

  {

  init: (messages) ->
    @functions = {}
    @messages = {}

    _.each messages, (value, key) =>
      if (regexp.test(value))
        @functions[key] = (varargs...) =>
          replace.apply(window, [key, value].concat(varargs))
      else
        @messages[key] = value

  getFunctions: ->
    @functions

  getMessages: ->
    @messages

  get: (key, varargs...) ->
    if @messages[key] then @messages[key] else @functions[key]?(varargs)

  }