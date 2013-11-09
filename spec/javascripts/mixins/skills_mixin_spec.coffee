describe "SkillsMixin", ->
  describe "#init", ->
            
    it "sets #allSkills", ->
      T.model = setupSession()
      expect(T.model.get("allSkills.length")).to.be.eq SeeSpotRun.get("skillsIdMap.length")
      
    it "sets #defaultConditionsMask", ->
      
      
  describe "#decodeSkills", ->
    
    beforeEach -> T.model = setupSession(sit_and_come_with_leash)
      
    it "it defaults to empty", ->
      T.model = setupSession()
      expect(T.model.get("skillsMask")).to.match /[0]+/
      
    it "accepts encoded skills and sets the #skillsMask", ->
      expect(T.model.get("skillsMask")).to.match /[01]+1/
      
    it "sets the #skillConditions Array", ->
      expect(T.model.get("skillConditions")).to.be.an "Array"
      expect(T.model.get("skillConditions.firstObject")).to.match /[01]+1/
      
    it "#skills should returns skills specified in encoded skills", ->
      expect(T.model.get("skills.length")).to.eq 2
  
    it "each of #skills should have the proper #conditionsMask", ->
      T.model.get("skills").forEach (skill) ->
        expect(skill.get("conditionsMask")).to.match /[01]+1/
        
  describe "#skills", ->
    
    beforeEach -> T.model = setupSession(sit_and_come_with_leash)
    
    it "updates when #skillsMask is changed", ->
      expect(T.model.get("skills.length")).to.eq 2
      Em.run -> T.model.set "skillsMask", modifyEmptyMask("1", "Skill")
      expect(T.model.get("skills.length")).to.eq 1
      
    it "updates underlying conditions when #conditionsMask is changed", ->
      expect(T.model.get("skills.firstObject.conditions.length")).to.eq 1
      Em.run -> T.model.set "skills.firstObject.conditionsMask", modifyEmptyMask("11", "Skill")
      expect(T.model.get("skills.firstObject.conditions.length")).to.eq 2
  