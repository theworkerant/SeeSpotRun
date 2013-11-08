SeeSpotRun.SkillsProxy = Em.ArrayProxy.extend()
SeeSpotRun.SkillProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(@get("id")))
    if @session.get("skillsMask") and parseInt(@session.get("skillsMask")[index]) then true else false
  .property("session.skillsMask")
  
SeeSpotRun.SkillsMixin = Em.Mixin.create

  init: ->
    @_super()

    @set "allSkills", SeeSpotRun.SkillsProxy.create
      content: @store.all("skill").map (skill) -> 
          
        SeeSpotRun.SkillProxy.extend(SeeSpotRun.ConditionsMixin).create
          store: @store
          session: @
          conditionsMask: SeeSpotRun.get("emptyConditionsMask")
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
      
    @set("skillConditions", split.slice(1))
    @set("skillsMask", split[0])
    
    active_index = 0
    @get("allSkills").forEach (skill) ->
      sindex = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(skill.get("id")))
      if parseInt(@get("skillsMask")[sindex])
        skill.set "conditionsMask", @get("skillConditions")[active_index]
        active_index++
      else
        skill.set "conditionsMask", SeeSpotRun.get("emptyConditionsMask")
    ,@

    
  skills: Em.computed ->
    ids = []
    for pos in [0..(@get("skillsMask").length-1)]
      ids.push(SeeSpotRun.get("skillsIdMap")[pos]) if parseInt(@get("skillsMask")[pos])
      
    @get("allSkills").filter (skill) -> ids.contains(parseInt(skill.get("id")))
  .property("skillsMask")

  skillsMaskObs: Em.observer ->
    encoded = Bitmask.encode(@get("skillsMask"))
    @get("skills").forEach (skill) -> encoded += ".#{Bitmask.encode(skill.get("conditionsMask"))}" if skill.get("conditionsMask")
    @set("skills_encoded", encoded)
  .observes("skillsMask","skills.@each.conditionsMask")
  
  defaultConditionsMask: Em.computed ->
    if @get("default_conditions_encoded") then Bitmask.decode(@get("default_conditions_encoded")) else SeeSpotRun.get("emptyConditionsMask")
  .property("default_conditions_encoded")

