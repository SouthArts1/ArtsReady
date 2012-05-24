class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    'assessment?tab=:tab': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @assessment = options.assessment

    @progressView = new Artsready.Views.AssessmentsProgress
      model: @assessment
    $('.progress-container').empty().append(@progressView.el)

    @navView = new Artsready.Views.AssessmentsNav(model: @assessment)
    $('.top-nav').replaceWith(@navView.render().el)

  show: (tab) =>
    section = tab || @assessment.get('default_section')
    @assessment.set('current_section', section)
    answers = @assessment.section(section).get('answers')

    @answersView = new Artsready.Views.AnswersIndex(collection: answers)
    @$el.empty().append(@answersView.render().el)

