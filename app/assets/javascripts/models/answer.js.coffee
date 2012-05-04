class Artsready.Models.Answer extends Backbone.RelationalModel
  isComplete: =>
    @preparedness && @priority

