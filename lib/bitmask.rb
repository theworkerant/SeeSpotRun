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
end