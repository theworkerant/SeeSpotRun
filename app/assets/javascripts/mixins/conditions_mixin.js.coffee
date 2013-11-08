SeeSpotRun.ConditionProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("conditionsIdMap").indexOf(parseInt(@get("id")))
    if parseInt(@get("skill.activeMask")[index]) then true else false
  .property("skill.activeMask")

SeeSpotRun.ConditionsMixin = Em.Mixin.create
  init: ->
    @_super()
    
    @set "allConditions", Em.ArrayProxy.create
      content: @store.all("condition").map (condition) -> 
        SeeSpotRun.ConditionProxy.create
          skill: @
          content: condition.getProperties("id", "name", "category", "difficulty", "point_basis")
      ,@
  
  restrictionsMask: Em.computed ->
    if @get("restrictions") then Bitmask.decode(@get("restrictions"),"condition") else SeeSpotRun.get("emptyConditionsMask")
  .property("restrictions")
  
  activeMask: Em.computed ->
    Bitmask.activeComparison(@get("conditionsMask"), @get("restrictionsMask"))
  .property("conditionsMask", "restrictionsMask")
  
  conditions: Em.computed ->
    ids = []
    self = @
    # console.log  "restrictions mask: #{self.get("restrictionsMask")}"
    # console.log  "conditions mask: #{self.get("conditionsMask")}"
    # console.log  "active mask: #{self.get("activeMask")}"
    for pos in [0..(@get("conditionsMask").length-1)]
      ids.push(SeeSpotRun.get("conditionsIdMap")[pos]) if parseInt(self.get("activeMask")[pos])
      
    @get("allConditions").filter (condition) -> ids.contains(parseInt(condition.get("id")))
  .property("activeMask")
  
  categoriesAvailable: Em.computed ->
    @get("unrestrictedConditions").mapBy("category").uniq()
  .property("unrestrictedConditions")
  
  conditionsForCategories: Em.observer ->
    self = @
    @get("categoriesAvailable").forEach (category) ->
      singular_match = category.match(/(.*?)[s]$/)
      singular = if singular_match then singular_match[1] else category
      Em.defineProperty self, "#{singular}Conditions", Ember.computed( ->
       @get("unrestrictedConditions").filterProperty "category", category
      ).property("#{category}.[]")
      
  .observes("unrestrictedConditions").on("init")
    
  unrestrictedConditions: Em.computed ->
    ids = []
    self = @
    for pos in [0..(@get("restrictionsMask").length-1)]
      ids.push(SeeSpotRun.get("conditionsIdMap")[pos]) unless parseInt(self.get("restrictionsMask")[pos])
      
    @get("allConditions").filter (condition) -> ids.contains(parseInt(condition.get("id")))
  .property("restrictionsMask")
  
  # controlConditions: Em.computed(-> @get("allConditions").filterProperty("category", "controls") ).property("allConditions")