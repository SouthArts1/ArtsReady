class Artsready.Models.AssessmentSection extends Backbone.RelationalModel
  relations: [
    {
      type: Backbone.HasMany
      key: 'answers'
      relatedModel: 'Artsready.Models.Answer'
      collectionType: 'Artsready.Collections.Answers'
      reverseRelation:
        key: 'section'
        includeInJSON: false
    }
  ]

  isCurrent: =>
    @get('assessment').get('current_section') == @get('name')