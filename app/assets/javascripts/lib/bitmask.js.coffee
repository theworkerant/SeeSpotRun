window.Bitmask = 
  decode: (encoded, type) ->  
    string = new BigNumber(encoded,36).toString(2)
    @adjust(string, type)
    
  encode: (mask, type) ->  
    mask = new BigNumber(mask,2).toString(36)

  adjust: (string, type) ->
    switch type
      when "skill"
        size  = SeeSpotRun.get("emptySkillsMask").length
      when "condition"
        size = SeeSpotRun.get("emptyConditionsMask").length
    
    string  = string.substring(string.length-size)
    while string.length < size
      string = "0" + string
    string
