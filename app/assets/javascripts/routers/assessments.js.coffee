class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    'assessment?tab=:tab': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @$progressEl = $('.progress-container')
    @answers = options.answers

  show: (tab) =>
    @answersView = new Artsready.Views.AnswersIndex(collection: @answers)
    @$el.empty().append(@answersView.render().el)

    @progressView = new Artsready.Views.AssessmentsProgress(collection: @answers)
    @$progressEl.empty().append(@progressView.render().el)

