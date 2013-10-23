window.Bitmask = 
  decode: (encoded, type) ->  
    string = new BigNumber(encoded,36).toString(2)
    @adjust(string, type)
    
  encode: (mask, type) ->  
    mask = new BigNumber(mask,2).toString(36)

  adjust: (mask, type) ->
    switch type
      when "skill"
        size  = SeeSpotRun.get("emptySkillsMask").length
      when "condition"
        size = SeeSpotRun.get("emptyConditionsMask").length
    
    mask = mask.substring(mask.length-size)
    while mask.length < size
      mask = "0" + mask
    mask
