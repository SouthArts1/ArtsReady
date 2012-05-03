class Artsready.Views.AnswersShow extends Backbone.View
  className: 'section'

  template: JST['answers/show']

  events:
    'click .respond': 'startResponding'

  initialize: ->
    @model.on('change:answering', @render)

  render: =>
    @$el.html(@template(answer: @model.toJSON()))
    return this

  startResponding: =>
    @model.set('answering', true)

