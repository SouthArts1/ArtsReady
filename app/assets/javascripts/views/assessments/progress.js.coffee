class Artsready.Views.AssessmentsProgress extends Backbone.View
  template: JST['assessments/progress']

  initialize: ->
    # TODO: use an assessment instead of a collection of answers
    @updateFromAnswer(@collection.first())
    @collection.on(
      'change:assessment_percentage_complete change:section_progress',
      @updateFromAnswer)
    # TODO: unbind

  render: =>
    @$el.html(@template(
      message: 'Assessment is'
      percent: @percent
      section_progress: @section_progress
    ))
    return this

  updateFromAnswer: (model) =>
    @section_progress = model.get('section_progress')
    @percent = model.get('assessment_percentage_complete')
    @render()

