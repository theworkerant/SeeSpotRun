class Session < ActiveRecord::Base
  belongs_to :user
  
  
  def process
    mask = Bitmask.new(skills)
    
    # get skill IDs
    skills = mask.skills
    
    # get conditions for skills
    skills.each do |skill|
      conditions = mask.conditions(skill)
    end
    
    # calculate skill difficulty
    
    # points for categories
    # points overall
    
    # track improvement based on self-reported performance
    
    # achievement processing
    
    # get previous session, decide streak
  end
end
