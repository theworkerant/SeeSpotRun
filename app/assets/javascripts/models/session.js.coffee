SeeSpotRun.Session = DS.Model.extend SeeSpotRun.SessionAssociationsMixin,
  
  skills_encoded:             attr "string"
  default_conditions_encoded: attr "string"
      