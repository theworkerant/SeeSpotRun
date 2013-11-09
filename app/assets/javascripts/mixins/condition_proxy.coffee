# Allows for database Conditions to remain unmodified
SeeSpotRun.ConditionProxy = Em.ObjectProxy.extend
  selected: Em.computed ->
    index = SeeSpotRun.get("conditionsIdMap").indexOf(parseInt(@get("id")))
    if parseInt(@get("skill.activeMask")[index]) then true else false
  .property("skill.activeMask")
