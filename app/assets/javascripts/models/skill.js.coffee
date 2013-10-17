SeeSpotRun.Skill = DS.Model.extend
  name:         attr "string"
  category:     attr "string"
  point_basis:  attr "number"
  
  restricted_conditions: hasMany "condition"
  conditions:  Em.computed( -> @store.all("condition") ).property()
  
  availableConditions: Em.computed ->
    @get("conditions").reject ((condition) -> @get("restricted_conditions").contains(condition)), @
  .property("conditions")
  
  # conditionsByCategory: Em.observer (category) -> 
  #   
  # .observes("availableConditions")
  controlConditions: Em.computed(-> @get("availableConditions").filterProperty("category", "control") ).property("availableConditions")
  
