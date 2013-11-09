describe "ConditionProxy", ->
  
  describe "#selected", ->
    it "tells whether it is active on the Skill", ->
      T.model = setupSession("1.1")
      T.skill = T.model.get("skills.firstObject")
      
      expect(T.skill.get("allConditions.firstObject.selected")).to.be true
      expect(T.skill.get("allConditions.lastObject.selected")).to.be false
    