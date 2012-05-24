class Artsready.Models.Assessment extends Backbone.RelationalModel
  relations: [
    {
      type: Backbone.HasMany
      key: 'sections'
      relatedModel: 'Artsready.Models.AssessmentSection'
      collectionType: 'Artsready.Collections.AssessmentSections'
      reverseRelation:
        key: 'assessment'
    }
  ]

  section: (name) => @get('sections').findByName(name)
  currentSection: => @section(@get('current_section'))

