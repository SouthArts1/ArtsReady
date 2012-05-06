class Artsready.Views.AnswersShow extends Backbone.View
  className: 'section'

  template: JST['answers/show']

  events:
    'click .respond': 'startAnswer'
    'change .answer input': 'updateAnswer'
    'submit .answer form': 'submitAnswer'
    'click .skip_answer': 'skipAnswer'
    'click .reconsider_answer': 'reconsiderAnswer'

  initialize: ->
    @model.on('change:answering change:was_skipped', @render)
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
    this.$('input[type=submit]').attr('disabled',
      this.$('input[name=preparedness]:checked, input[name=priority]:checked')
        .length < 2)

  submitAnswer: (event) =>
    event.preventDefault()

    @model.save(
      preparedness: this.$('input[name=preparedness]:checked').val()
      priority: this.$('input[name=priority]:checked').val()
    )

  answerSaved: (answer) =>
    @model.set(answering: false)

  answerError: (answer) =>
    console.log(event)

  skipAnswer: (event) =>
    @model.save({was_skipped: true, answering: false}, wait: true)

  reconsiderAnswer: (event) =>
    @model.save({was_skipped: false, answering: false}, wait: true)

