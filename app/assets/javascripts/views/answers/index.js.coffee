class Artsready.Views.AnswersIndex extends Backbone.View

  template: JST['answers/index']

  render: =>
    @$el.html(@template(@model.toJSON()))
    return this

