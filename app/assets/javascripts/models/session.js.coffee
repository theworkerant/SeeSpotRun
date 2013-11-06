SeeSpotRun.Session = DS.Model.extend SeeSpotRun.SkillsMixin,
  
  skills_encoded:             attr "string"
  default_conditions_encoded: attr "string"
      