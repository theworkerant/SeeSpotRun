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

  activeComparison: (conditions, restrictions) ->
    index   = 0
    result  = ""
    
    while conditions.length > index
      cond_slice = parseInt(conditions[index],2)
      rest_slice = parseInt(restrictions[index],2)
      
      result = result + (cond_slice & ~rest_slice).toString(2)
      
      index++
      
    result