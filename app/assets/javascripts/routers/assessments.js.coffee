class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    '': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @model = options.model
    @answersView = new Artsready.Views.AnswersIndex(model: @model)

  show: =>
    @$el.empty().append(@answersView.render().el)

