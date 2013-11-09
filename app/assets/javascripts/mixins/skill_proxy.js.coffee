# Allows for database Skills to remain unmodified
SeeSpotRun.SkillProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(@get("id")))
    if @session.get("skillsMask") and parseInt(@session.get("skillsMask")[index]) then true else false
  .property("session.skillsMask")
