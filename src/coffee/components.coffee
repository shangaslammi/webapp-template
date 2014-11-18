
components = [
  'example-component'
]

define (require) ->
  ko = require 'knockout'

  addComponent = (name) ->
    ko.components.register name,
      viewModel: require: "components/#{name}"
      template: require: "text!../../components/#{name}.html"

  addComponent(name) for name in components
  return
