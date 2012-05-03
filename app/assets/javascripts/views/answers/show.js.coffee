class Artsready.Views.AnswersShow extends Backbone.View
  className: 'section'

  template: JST['answers/show']

  events:
    'click .respond': 'startResponding'

  render: =>
    @$el.html(@template(answer: @model.toJSON()))
    return this

  startResponding: =>
    alert('respond')

