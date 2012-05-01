window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    new Artsready.Routers.Assessments(model: @assessment)
    Backbone.history.start(pushState: true)

    alert 'Hello from Backbone!'

$(document).ready ->
  Artsready.init
    assessment:
      answers_count: 100
      completed_answers_count: 6


