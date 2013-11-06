SeeSpotRun.SkillsProxy = Em.ArrayProxy.extend()
SeeSpotRun.SkillProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(@get("id")))
    if @session.get("skills_mask") and parseInt(@session.get("skills_mask")[index]) then true else false
  .property("session.skills_mask")
  
SeeSpotRun.SkillsMixin = Em.Mixin.create

  init: ->
    @_super()
    
    @set "allSkills", SeeSpotRun.SkillsProxy.create
      content: @store.all("skill").map (skill) -> 
          
        SeeSpotRun.SkillProxy.extend(SeeSpotRun.ConditionsMixin).create
          store: @store
          session: @
          conditions_mask: SeeSpotRun.get("emptyConditionsMask")
          content: skill.getProperties("id", "name", "difficulty", "point_basis", "restrictions")
      ,@

  didLoad: ->
    @_super()
    @decodeSkills()
    
  decodeSkills: ->
    encoded = if @get("skills_encoded") then @get("skills_encoded") else "0"
    
    split = encoded.split(".")
    for i in [0..split.length-1]
      if i is 0
        split[i] = Bitmask.decode(split[i], "skill")
      else
        split[i] = Bitmask.decode(split[i], "condition")
      
    @set("skill_conditions", split.slice(1))
    @set("skills_mask", split[0])
    
    active_index = 0
    @get("allSkills").forEach (skill) ->
      sindex = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(skill.get("id")))
      if parseInt(@get("skills_mask")[sindex])
        skill.set "conditions_mask", @get("skill_conditions")[active_index]
        active_index++
      else
        skill.set "conditions_mask", SeeSpotRun.get("emptyConditionsMask")
    ,@

    
  skills: Em.computed ->
    ids = []
    for pos in [0..(@get("skills_mask").length-1)]
      ids.push(SeeSpotRun.get("skillsIdMap")[pos]) if parseInt(@get("skills_mask")[pos])
      
    @get("allSkills").filter (skill) -> ids.contains(parseInt(skill.get("id")))
  .property("skills_mask")

  skills_mask_obs: Em.observer ->
    encoded = Bitmask.encode(@get("skills_mask"))
    @get("skills").forEach (skill) -> encoded += ".#{Bitmask.encode(skill.get("conditions_mask"))}" if skill.get("conditions_mask")
    @set("skills_encoded", encoded)
  .observes("skills_mask","skills.@each.conditions_mask")
  
  default_conditions_mask: Em.computed ->
    if @get("default_conditions_encoded") then Bitmask.decode(@get("default_conditions_encoded")) else SeeSpotRun.get("emptyConditionsMask")
  .property("default_conditions_encoded")

