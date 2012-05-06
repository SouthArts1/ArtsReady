window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @answers = new Artsready.Collections.Answers(data.answers)
    #@assessment = new Artsready.Models.Assessment(data.assessment)
    new Artsready.Routers.Assessments(answers: @answers)
    Backbone.history.start(pushState: true)

$(document).ready ->
  Artsready.init
    assessment:
      answers_count: 100
      completed_answers_count: 6
  
    answers: window.answers
