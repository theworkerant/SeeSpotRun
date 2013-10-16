SeeSpotRun.Session = DS.Model.extend
  skills:     hasMany "skill"
  isTemplate: attr "boolean"
  