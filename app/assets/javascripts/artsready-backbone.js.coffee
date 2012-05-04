window.Artsready =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @assessment = new Artsready.Models.Assessment(data.assessment)
    new Artsready.Routers.Assessments(model: @assessment)
    Backbone.history.start(pushState: true)

$(document).ready ->
  Artsready.init
    assessment:
      answers_count: 100
      completed_answers_count: 6
      answers: [
        {
          question_description: "Ready means not unready.",
          question_help_html: "Some more info about not being unready.",
          was_skipped: false
        },
        {
          question_description: "Ready means after readx."
          was_skipped: true
        }
      ]


