class Artsready.Views.AnswersShow extends Backbone.View
  className: 'section'

  template: JST['answers/show']

  events:
    'click .respond': 'startAnswer'
    'change .answer input': 'updateAnswer'
    'submit .answer form': 'submitAnswer'

  initialize: ->
    @model.on('change:answering', @render)
    @model.on('change:preparedness, change:priority', @validateAnswer)

  render: =>
    @$el.html(@template(answer: @model.toJSON()))
    initializeInfoBubbles(@$el)
    return this

  startAnswer: =>
    @model.set('answering', true)

  updateAnswer: (event) =>
    @model.set(event.target.name, event.target.value)

  validateAnswer: =>
    this.$('input[type=submit]').attr('disabled', !@model.isComplete)

  submitAnswer: =>
    @model.set(answering: false, answered: true)
