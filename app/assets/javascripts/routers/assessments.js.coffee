class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    'assessment?tab=:tab': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @answers = options.answers

  show: (tab) =>
    @answersView = new Artsready.Views.AnswersIndex(collection: @answers)
    @$el.empty().append(@answersView.render().el)
