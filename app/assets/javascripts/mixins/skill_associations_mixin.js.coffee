SeeSpotRun.ConditionProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("conditionsIdMap").indexOf(parseInt(@get("id")))
    if parseInt(@get("skill.activeMask")[index]) then true else false
  .property("skill.activeMask")

SeeSpotRun.SkillAssociationsMixin = Em.Mixin.create
  init: ->
    @_super()
    
    @set "allConditions", Em.ArrayProxy.create
      content: @store.all("condition").map (condition) -> 
        SeeSpotRun.ConditionProxy.create
          skill: @
          content: condition.getProperties("id", "name", "difficulty", "point_basis")
      ,@
  
  restrictions_mask: Em.computed ->
    if @get("restrictions") then Bitmask.decode(@get("restrictions"),"condition") else SeeSpotRun.get("emptyConditionsMask")
  .property("restrictions")
  
  activeMask: Em.computed ->
    mask = parseInt(@get("conditions_mask"),2) & ~parseInt(@get("restrictions_mask"),2)
    Bitmask.adjust(mask.toString(2), "condition")
  .property("conditions_mask", "restrictions_mask")
  
  conditions: Em.computed ->
    ids = []
    self = @
    # console.log  "restrictions mask: #{self.get("restrictions_mask")}"
    # console.log  "conditions mask: #{self.get("conditions_mask")}"
    # console.log  "active mask: #{self.get("activeMask")}"
    for pos in [0..(@get("conditions_mask").length-1)]
      ids.push(SeeSpotRun.get("conditionsIdMap")[pos]) if parseInt(self.get("activeMask")[pos])
      
    @get("allConditions").filter (condition) -> ids.contains(parseInt(condition.get("id")))
  .property("activeMask")
  
  unrestrictedConditions: Em.computed ->
    ids = []
    self = @
    for pos in [0..(@get("restrictions_mask").length-1)]
      ids.push(SeeSpotRun.get("conditionsIdMap")[pos]) unless parseInt(self.get("restrictions_mask")[pos])
      
    @get("allConditions").filter (condition) -> ids.contains(parseInt(condition.get("id")))
  .property("restrictions_mask")
  
  controlConditions: Em.computed(-> @get("conditions").filterProperty("category", "control") ).property("conditions")