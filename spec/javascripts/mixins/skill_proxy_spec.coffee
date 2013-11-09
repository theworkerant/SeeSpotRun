describe "SkillProxy", ->
  
  describe "#selected", ->
    it "tells whether it is active on the Session", ->
      T.model = setupSession("1.1")      
      expect(T.model.get("allSkills.firstObject.selected")).to.be true
      expect(T.model.get("allSkills.lastObject.selected")).to.be false
    