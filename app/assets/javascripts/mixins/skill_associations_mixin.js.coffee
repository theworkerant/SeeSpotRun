# SeeSpotRun.SessionSkillsProxy = Em.ArrayProxy.extend
#   conditions_mask: Em.computed ->
#   .property()
#
#   skills_mask_obs: Em.observer ->
#     encoded = parseInt(@get("skills_mask"),2)
#     for i in [0..@get("skill_conditions").length-1]
#       encoded += ":#{parseInt(@get("skill_conditions")[i],2)}"
#     @set("skills_encoded", encoded)
#   .observes("skills_mask")
#
#   default_conditions_mask: Em.computed ->
#     if @get("default_conditions_encoded") then @get("default_conditions_encoded").toString(2) else SeeSpotRun.get("emptyConditionsMask")
#   .property("default_conditions_encoded")

SeeSpotRun.ConditionProxy = Em.ObjectProxy.extend
  bla: Em.computed(-> "bla").property()

SeeSpotRun.SkillAssociationsMixin = Em.Mixin.create
  allConditions: Em.computed ->
    Em.ArrayProxy.create
      content: @store.all("condition").map (condition) -> 
        SeeSpotRun.ConditionProxy.create
          content: condition.getProperties("id", "name", "difficulty", "point_basis")
  .property()
  
  restrictions_mask: Em.computed ->
    if @get("restrictions") then Mask.decode(@get("restrictions"),"condition") else SeeSpotRun.get("emptyConditionsMask")
  .property("restrictions")
  
  activeMask: Em.computed ->
    mask = parseInt(@get("conditions_mask"),2) & ~parseInt(@get("restrictions_mask"),2)
    Mask.adjust(mask.toString(2), "condition")
  .property("conditions_mask", "restrictions_mask")
  conditions: Em.computed ->
    ids = []
    self = @
    console.log  "restrictions mask: #{self.get("restrictions_mask")}"
    console.log  "conditions mask: #{self.get("conditions_mask")}"
    console.log  "active mask: #{self.get("activeMask")}"
    for pos in [0..(@get("conditions_mask").length-1)]
      ids.push(SeeSpotRun.get("conditionsIdMap")[pos]) if parseInt(self.get("activeMask")[pos])
      
    @get("allConditions").filter (condition) -> ids.contains(parseInt(condition.get("id")))
  .property("activeMask")

  
  # conditions: Em.computed( -> @store.all("condition") ).property()
  # availableConditions: Em.computed ->
  #   allowed_ids = []
  #   for pos in [0..(@get("conditions").length-1)]
  #     allowed_ids.push(SeeSpotRun.get("skillsIdMap")[pos]) unless parseInt(@get("restrictions_mask")[pos])
  #   @get("conditions").filter (condition) -> allowed_ids.contains(parseInt(condition.get("id")))
  # .property("conditions")
  
  controlConditions: Em.computed(-> @get("conditions").filterProperty("category", "control") ).property("conditions")