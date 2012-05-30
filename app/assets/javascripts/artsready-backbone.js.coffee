window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    @assessmentsRouter =
      new Artsready.Routers.Assessments(assessment: @assessment)
    Backbone.history.start(root: '/assessment')

$(document).ready ->
  Artsready.init
    assessment: window.assessment

