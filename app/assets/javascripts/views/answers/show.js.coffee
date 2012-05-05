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
    @model.on('sync', @answerSaved)
    @model.on('error', @answerError)
    # TODO: unbind on removal

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

  submitAnswer: (event) =>
    event.preventDefault()

    @model.save()

  answerSaved: (answer) =>
    @model.set(answering: false)

  answerError: (answer) =>
    console.log(event)

