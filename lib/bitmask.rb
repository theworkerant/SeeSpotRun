 class Bitmask

  class << self
    
    def skills_id_map
      Skill.order("id ASC").to_a.reduce([]) do |map, skill|
        map << skill.id
      end.reverse
    end    
    def blank_skills_mask
      "0"*self.skills_id_map.length
    end
    
    def conditions_id_map
      Condition.order("id ASC").to_a.reduce([]) do |map, condition|
        map << condition.id
      end.reverse
    end
    def blank_conditions_mask
      "0"*self.conditions_id_map.length
    end
    
  end
  
  attr_accessor :skills_mask, :skill_conditions
  
  def initialize(encoded_bitmask="")
    @skills_mask      = Bitwise.new()
    @skill_conditions = []
    
    split = encoded_bitmask.split(".")
    split.each_with_index do |s,i|
      if i == 0
        @skills_mask = adjust_mask( s.to_i(36).to_s(2), "skill" )
      else
        @skill_conditions << adjust_mask( s.to_i(36).to_s(2), "condition" )
      end
    end
  end
  
  def skill_ids
    self.class.skills_id_map.values_at(*@skills_mask.indexes).compact
  end
  def skills
    Skill.where(id: skill_ids)
  end
  def condition_ids(skill)
    id = self.class.skills_id_map.index(skill.id)
    mask = @skill_conditions[@skills_mask.indexes.index(id)]
    self.class.conditions_id_map.values_at(*mask.indexes).compact
  end
  def conditions(skill)
    Condition.where(id: condition_ids(skill))
  end
  
  private 
  def adjust_mask(mask, type)
    size = case type
    when "skill"
      self.class.blank_skills_mask.length
    when "condition"
      self.class.blank_conditions_mask.length
    end

    # mask = mask[mask.length-size..-1] if mask.length > size
    while mask.length < size do
      mask = "0" + mask
    end
    b=Bitwise.new()
    b.bits = mask
    b
  end
  
end