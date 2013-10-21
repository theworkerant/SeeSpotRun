window.Mask = 
  parse: (hex, type) ->  
    string  = hexToBinary(hex)
    @adjust(string, type)

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
