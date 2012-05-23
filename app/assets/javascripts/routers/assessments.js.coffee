class Artsready.Routers.Assessments extends Backbone.Router
  routes:
    'assessment': 'show'
    'assessment?tab=:tab': 'show'

  initialize: (options) =>
    @$el = $('.questions')
    @$progressEl = $('.progress-container')
    $navEl = $('.top-nav')
    @assessment = options.assessment

    @navView = new Artsready.Views.AssessmentsNav(model: @assessment)
    $navEl.replaceWith(@navView.render().el)

  show: (tab) =>
    section = tab || @assessment.get('default_section')
    @assessment.set('current_section', section)
    answers = @assessment.section(section).get('answers')

    @answersView = new Artsready.Views.AnswersIndex(collection: answers)
    @$el.empty().append(@answersView.render().el)

    @progressView = new Artsready.Views.AssessmentsProgress(collection: answers)
    @$progressEl.empty().append(@progressView.render().el)

    @navView.render()
