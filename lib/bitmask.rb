class Bitmask

  class << self
    
    def skills_id_map
      Skill.order("id ASC").to_a.reduce([]) do |map, skill|
        map << skill.id
      end
    end
    def skills_name_map
      Skill.order("id ASC").to_a.reduce([]) do |map, skill|
        map << skill.name
      end
    end
    
    def conditions_id_map
      Condition.order("id ASC").to_a.reduce([]) do |map, condition|
        map << condition.id
      end
    end
    def conditions_name_map
      Condition.order("id ASC").to_a.reduce([]) do |map, condition|
        map << condition.name
      end
    end
    
  end
  
  SKILL_IDS             = self.skills_id_map
  SKILL_NAMES           = self.skills_name_map
  BLANK_SKILLS_MASK     = "0"*SKILL_IDS.length

  CONDITION_IDS         = self.conditions_id_map
  CONDITION_NAMES       = self.conditions_name_map
  BLANK_CONDITIONS_MASK = "0"*CONDITION_IDS.length
  
  attr_accessor :skills_mask, :skill_conditions
  
  def initialize(encoded_bitmask)
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
  
  def adjust_mask(mask, type)
    size = case type
    when "skill"
      BLANK_SKILLS_MASK.length
    when "condition"
      BLANK_CONDITIONS_MASK.length
    end

    mask = mask[mask.length-size..-1] if mask.length > size
    while mask.length < size do
      mask = "0" + mask
    end
    b=Bitwise.new()
    b.bits = mask
    b
  end
  
  def skill_ids
    SKILL_IDS.values_at(*@skills_mask.indexes).compact
  end
  def skills
    Skill.where(id: skill_ids)
  end
  def condition_ids(skill)
    id = SKILL_IDS.index(skill.id)
    mask = @skill_conditions[@skills_mask.indexes.index(id)]
    CONDITION_IDS.values_at(*mask.indexes).compact
  end
  def conditions(skill)
    Condition.where(id: condition_ids(skill))
  end
  
end