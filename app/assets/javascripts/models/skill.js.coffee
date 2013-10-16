SeeSpotRun.Skill = DS.Model.extend
  conditions:   hasMany "condition"
  
  name:         attr "string"
  category:     attr "string"
  point_basis:  attr "number"
  