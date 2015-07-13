
require.config
  baseUrl: "js/modules"
  paths:
    'text': '../vendor/text-2.0.12'
    'jquery': '../vendor/jquery-2.1.4.min'
    'knockout': '../vendor/knockout-3.3.0.min'

define (require) ->
  require 'components'

  ko = require 'knockout'

  ko.applyBindings {}
