SeeSpotRun.SessionsFormController = Em.ObjectController.extend
  # skillsDidChange: Em.observer ->
  #   Em.run.once @, "updateSkills"
  # .observes "skills_encoded"
  #   
  # updateSkills: -> @replaceRoute queryParams: {skills_encoded: @get('skills_encoded')}

  actions:
    save: ->
      $.ajax
        type: if @get("id") then "PUT" else "POST"
        data: 
          session:
            skills: @get "skills_encoded"
            
        url: if @get("id") then "/sessions/#{@get("id")}" else "/sessions"
        context: @
      .then(
        (response) ->
          @set "id", response.id
          @set "content", null
      ,
        (response) ->
          debugger
      )
    addSkill: (skill) -> 
      at = SeeSpotRun.get("skillsIdMap").indexOf(parseInt(skill.get("id")))
      @set("skills_mask", @get("skills_mask").replaceAt(at, "1"))
      
    addCondition: (skill, condition) -> 
      at = SeeSpotRun.get("conditionsIdMap").indexOf(parseInt(condition.get("id")))
      skill.set("conditions_mask", skill.get("conditions_mask").replaceAt(at, "1"))
      
    debugme: -> debugger