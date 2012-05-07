window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    new Artsready.Routers.Assessments(assessment: @assessment)
    Backbone.history.start(pushState: true)

$(document).ready ->
  Artsready.init
    assessment: window.assessment

