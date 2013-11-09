describe "ConditionsMixin", ->    

  beforeEach -> T.model = setupSkill()
  
  describe "#init", ->
      
    it "sets #allConditions", ->
      expect(T.model.get("allConditions.length")).to.be.eq SeeSpotRun.get("conditionsIdMap.length")
      
    it "starts with a blank #conditionsMask", ->
      expect(T.model.get("conditionsMask")).to.be.eq SeeSpotRun.get("emptyConditionsMask")
    
  describe "#conditions", ->
    it "defaults to empty", ->
      expect(T.model.get("conditions.length")).to.be.eq 0
      
    it "returns conditions based on the #activeMask", ->
      Em.run -> T.model.set("conditionsMask", modifyEmptyMask("1", "Condition"))
      expect(T.model.get("conditions.length")).to.be.eq 1
  
  describe "#unrestrictedConditions", ->
    it "defaults to empty", ->
      expect(T.model.get("unrestrictedConditions.length")).to.eq SeeSpotRun.get("conditionsIdMap.length")
          
    it "returns conditions not in #restrictionsMask", ->
      Em.run -> T.model.set("restrictionsMask", modifyEmptyMask("1", "Condition"))
      expect(T.model.get("unrestrictedConditions.length")).to.eq SeeSpotRun.get("conditionsIdMap.length")-1

  describe "#categoriesAvailable", ->
    it "yields an array of categories", ->
      categories = T.model.get("categoriesAvailable")
      expect(categories).to.be.an "Array"
      expect(categories.contains("controls")).to.be true
      
  describe "#conditionsByCategories", ->
    it "defines methods for gettings conditions by category", ->
      expect(Ember.canInvoke(T.model, "controlConditions"))