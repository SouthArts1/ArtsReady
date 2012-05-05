class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    '': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @model = options.model

  show: =>
    answers = new Artsready.Collections.Answers
    answers.fetch
      success: =>
        @answersView = new Artsready.Views.AnswersIndex(collection: answers)
        @$el.empty().append(@answersView.render().el)
