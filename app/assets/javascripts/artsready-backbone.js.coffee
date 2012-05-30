window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    @assessmentsRouter =
      new Artsready.Routers.Assessments(assessment: @assessment)
    if window.location.pathname.indexOf('/assessment') == 0
      Backbone.history.start(pushState: true, root: '/assessment')
  
$(document).ready ->
  Artsready.init
    assessment: window.assessment

