SeeSpotRun.Session = DS.Model.extend SeeSpotRun.SessionAssociationsMixin,
  skills_encoded:             attr "string"
  default_conditions_encoded: attr "string"
  
  didLoad: -> @decode_skills() unless Em.isEmpty @get("skills_encoded")
  
  decode_skills: ->
    split = @get("skills_encoded").split(":")
    for i in [0..split.length-1]
      if i is 0
        debugger
        split[i] = Mask.decode(split[i], "skill")
      else
        split[i] = Mask.decode(split[i], "condition")
      
    @set("skill_conditions", split.slice(1))
    @set("skills_mask", split[0])
    console.log "Skills: #{@get("skills_mask")}"
  
  skills_mask_obs: Em.observer ->
    encoded = Mask.encode(@get("skills_mask"))
    @get("skills").forEach (skill) -> encoded += ":#{Mask.encode(skill.get("conditions_mask"))}" if skill.get("conditions_mask")
    @set("skills_encoded", encoded)
  .observes("skills_mask","skills.@each.conditions.conditions_mask")
  
  default_conditions_mask: Em.computed ->
    if @get("default_conditions_encoded") then hexToBinary(@get("default_conditions_encoded")) else SeeSpotRun.get("emptyConditionsMask")
  .property("default_conditions_encoded")