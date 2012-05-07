window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    new Artsready.Routers.Assessments
      answers: @assessment.get('sections').
        findByName(data.current_section).get('answers')
    Backbone.history.start(pushState: true)

$(document).ready ->
  Artsready.init
    assessment: window.assessment
    current_section: window.current_section

