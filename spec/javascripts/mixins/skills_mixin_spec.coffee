describe "SeeSpotRun.SkillsMixin", ->
  describe "#init", ->
            
    it "sets #allSkills", ->
      T.model = setupModel()
      expect(T.model.get("allSkills.length")).to.be.eq SeeSpotRun.get("skillsIdMap.length")
      
  describe "#decodeSkills", ->
    
    beforeEach -> T.model = setupModel(sit_and_come_with_leash)
      
    it "it defaults to empty", ->
      T.model = setupModel()
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
    
    beforeEach -> T.model = setupModel(sit_and_come_with_leash)
    
    it "updates when #skillsMask is changed", ->
      expect(T.model.get("skills.length")).to.eq 2
      
      empty         = SeeSpotRun.get("emptySkillsMask")
      modified_mask = "#{empty.substr(0,empty.length-1)}1"

      Em.run -> T.model.set "skillsMask", modified_mask
      expect(T.model.get("skills.length")).to.eq 1
      
    it "updates underlying conditions when #conditionsMask is changed", ->
      expect(T.model.get("skills.firstObject.conditions.length")).to.eq 1

      empty         = SeeSpotRun.get("emptyConditionsMask")
      modified_mask = "#{empty.substr(0,empty.length-2)}11"
      
      Em.run -> T.model.set("skills.firstObject.conditionsMask", modified_mask)
      expect(T.model.get("skills.firstObject.conditions.length")).to.eq 2
    
setupModel = (skills_encoded) ->
  Em.run ->
    T.SomeModel = DS.Model.extend SeeSpotRun.SkillsMixin,
      store: T.store
      skills_encoded: skills_encoded
    
  someModel = new T.SomeModel
  Em.run -> someModel .trigger("didLoad")
  someModel
  