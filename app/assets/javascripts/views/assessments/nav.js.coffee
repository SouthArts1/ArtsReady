class Artsready.Views.AssessmentsNav extends Backbone.View
  template: JST['assessments/nav']
  tagName: 'ul'
  className: 'top-nav'

  initialize: =>
    @model.on('change:current_section', @render)

  events:
    'click a': 'changeSection'

  render: =>
    @$el.html(@template(assessment: @model))
    return this

  changeSection: (event) ->
    event.preventDefault()
    Artsready.assessmentsRouter.navigate(
      $(event.target).attr('href'), trigger: true)

