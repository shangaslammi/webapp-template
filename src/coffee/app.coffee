
require.config
  baseUrl: "/static/js/modules"
  paths:
    'text': '../vendor/text-2.0.12'
    'jquery': '../vendor/jquery-3.1.0.min'
    'knockout': '../vendor/knockout-3.4.0.min'
    'page': '../vendor/repage-2.0.2'

define (require) ->
  require 'components'

  ko = require 'knockout'

  ko.applyBindings {}
