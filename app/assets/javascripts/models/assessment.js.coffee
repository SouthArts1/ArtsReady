class Artsready.Models.Assessment extends Backbone.RelationalModel
  relations: [
    {
      type: Backbone.HasMany
      key: 'answers'
      relatedModel: 'Artsready.Models.Answer'
      collectionType: 'Artsready.Collections.Answers'
      reverseRelation:
        key: 'assessment'
    }
  ]

