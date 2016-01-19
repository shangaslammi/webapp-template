define (require) ->
  ko = require 'knockout'

  ko.components.register 'example-component',
    viewModel: require 'components/example-component'
    template:  require 'text!../../components/example-component.html'

  return
