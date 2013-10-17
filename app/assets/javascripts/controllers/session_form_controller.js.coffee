SeeSpotRun.SessionFormController = Em.ObjectController.extend
  selectedSkill: null
  
  actions:
    selectSkill: (skill) -> 
      @set("selectedSkill", skill)
  