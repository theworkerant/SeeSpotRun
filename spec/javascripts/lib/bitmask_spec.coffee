describe "Bitmask", ->
  describe "#decode", ->
    it "from base 36 string to base 2 string", ->
      # 3 == 011 or 0000011
      expect(Bitmask.decode("3", "skill")).to.eq modifyEmptyMask("11", "Skill")
  
  describe "#encode", ->
    it "from base 2 string to base 36 string", ->
      expect(Bitmask.encode(modifyEmptyMask("11", "Skill"), "skill")).to.eq "3"
      
  describe "#adjust", ->
    it "adjusts mask to match expected size", ->
      expect(Bitmask.adjust("001", "skill")).to.eq modifyEmptyMask("1", "Skill")
      
  describe "#activeWithRestrictions", ->    
    it "returns an active mask by comparing condition and restriction masks", ->
      session = setupSession("1.3")
      conditions = session.get("skills.firstObject.conditions")
      expect(Bitmask.activeWithRestrictions(modifyEmptyMask("11", "Condition"), SeeSpotRun.get("emptyConditionsMask"))).to.eq modifyEmptyMask("11", "Condition")
      expect(Bitmask.activeWithRestrictions(modifyEmptyMask("1011", "Condition"), modifyEmptyMask("1001", "Condition"))).to.eq modifyEmptyMask("0010", "Condition")
      expect(Bitmask.activeWithRestrictions(SeeSpotRun.get("emptyConditionsMask"), modifyEmptyMask("1011", "Condition"))).to.eq SeeSpotRun.get("emptyConditionsMask")