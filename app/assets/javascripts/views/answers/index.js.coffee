class Artsready.Views.AnswersIndex extends Backbone.View

  render: =>
    template = @template
    @collection.each (answer) =>
      view = new Artsready.Views.AnswersShow(model: answer)
      @$el.append(view.render().el)
    return this

