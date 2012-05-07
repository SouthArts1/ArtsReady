class Artsready.Collections.AssessmentSections extends Backbone.Collection
  model: Artsready.Models.AssessmentSection

  findByName: (name) =>
    @where(name: name)[0]
