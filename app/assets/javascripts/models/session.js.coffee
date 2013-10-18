SeeSpotRun.Session = DS.Model.extend SeeSpotRun.SessionAssociationsMixin,
  skills_encoded:             attr "string"
  default_conditions_encoded: attr "string"
  
  didLoad: -> @decode_skills() unless Em.isEmpty @get("skills_encoded")
  
  decode_skills: ->
    split = @get("skills_encoded").split(":")
    for i in [0..split.length-1]
      if i is 0
        split[i] = parseSkillsMask(split[i])
      else
        split[i] = parseConditionsMask(split[i])
      
    @set("skill_conditions", split.slice(1))
    @set("skills_mask", split[0])
  
  skills_mask_obs: Em.observer ->
    encoded = "#{parseInt(@get("skills_mask"),2)}"
    @get("skills").forEach (skill) -> encoded += ":#{parseInt(skill.get("conditions_mask"),2)}"
    @set("skills_encoded", encoded)
  .observes("skills_mask","skills.@each.conditions.conditions_mask")
  
  default_conditions_mask: Em.computed ->
    if @get("default_conditions_encoded") then @get("default_conditions_encoded").toString(2) else SeeSpotRun.get("emptyConditionsMask")
  .property("default_conditions_encoded")