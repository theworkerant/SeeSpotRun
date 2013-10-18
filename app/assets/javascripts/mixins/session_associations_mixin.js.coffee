SeeSpotRun.SkillsProxy = Em.ArrayProxy.extend()
SeeSpotRun.SkillProxy = Em.ObjectProxy.extend()
  # pushObject: (object) -> 
  #   debugger
  #   at = SeeSpotRun.get("skillsIdMap")[object.get("id")]
  #   @set("skills_mask", @get("skills_mask").replaceAt(at, "1"))
  
SeeSpotRun.SessionAssociationsMixin = Em.Mixin.create
  allSkills: Em.computed ->
    self = @
    conditions_mask = ""
    SeeSpotRun.SkillsProxy.create
      content: @store.all("skill").map (skill) -> 
        current_skill = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(skill.get("id")))
        conditions_mask = if parseInt(self.get("skills_mask")[current_skill]) then self.get("skill_conditions")[current_skill] else SeeSpotRun.get("emptyConditionsMask")
        
        SeeSpotRun.SkillProxy.extend(SeeSpotRun.SkillAssociationsMixin).create
          store: self.store
          conditions_mask: conditions_mask
          content: skill.getProperties("id", "name", "difficulty", "point_basis", "restrictions")
          
  .property()
  
  skills: Em.computed ->
    ids = []
    for pos in [0..(@get("skills_mask").length-1)]
      ids.push(SeeSpotRun.get("skillsIdMap")[pos]) if parseInt(@get("skills_mask")[pos])
      
    @get("allSkills").filter (skill) -> ids.contains(parseInt(skill.get("id")))
  .property("skills_mask")