
require.config
  baseUrl: "js/modules"
  paths:
    'jquery': '../vendor/jquery/jquery'
    'knockout': '../vendor/knockout.js/knockout'


define (require) ->

  $ = require 'jquery'

  $('#main').append('<p>Hello World</p>')
