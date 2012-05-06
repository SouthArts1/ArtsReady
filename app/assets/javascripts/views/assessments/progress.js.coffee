class Artsready.Views.AssessmentsProgress extends Backbone.View
  template: JST['assessments/progress']

  initialize: ->
    # TODO: use an assessment instead of a collection of answers
    @percent = @collection.first().get('assessment_percentage_complete')
    @collection.on('change:assessment_percentage_complete', @updatePercent)
    # TODO: unbind

  render: =>
    @$el.html(@template(
      message: 'Assessment is'
      percent: @percent
    ))
    return this

  updatePercent: (model) =>
    @percent = model.get('assessment_percentage_complete')
    @render()

