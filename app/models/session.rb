class Session < ActiveRecord::Base
  CHANGE_MEMORY = 2.week.ago
  belongs_to :user
  
  def process(reprocess: false, notify: false)
    mask  = Bitmask.new(skills)
    
    Rails.logger.debug "should notify? #{notify} -- reprocess: #{reprocess} -- ##{self.id}"
    
    list_storage  = 99
    
    points      = 143
    difficulty  = 5
    
    mask.skills.each do |skill|
      skill_tally(user, skill)
        
      mask.conditions(skill).each do |condition|
        condition_tally(user, skill, condition)
        skill_performance(user, skill, condition.point_basis) if condition.category == "performance"
      end
      
      # calculate difficulty somehow
      difficulty_performance(user, skill, difficulty)
      
      # Points overall
      point_tally user, skill, points
      
    end
    
    # track improvement based on self-reported performance
    
    # achievement processing
    
    # get previous session, decide streak
    
    # TODO This shouldn't go here, probably?
    Pusher.trigger("sessions", "session_processed", {message: "We processed your session and you got #{points} points! Amazzzssing!"}) if notify and Rails.env != "test"
  end
  def reprocess(delete: false)
    sessions  = self.class.where("created_at > ?", self.class::CHANGE_MEMORY).order("created_at ASC").limit(10)
    index     = sessions.index(self)
    
    sessions[0..index].each do |session|
      session.reverse
    end
    sessions[0..index].reverse.each_with_index do |session|
      session.process(reprocess: true, notify: (self == session)) unless delete and self == session
    end
  end
  def reverse
    mask = Bitmask.new(skills)
    redis = Redis.new(:host => "127.0.0.1", :port => 6379)
    
    points      = 0
    difficulty  = 5
    
    mask.skills.each do |skill|
      
      # Tallies
      REDIS.hincrby "user:1:tallies", "skill:#{skill.id}", -1
      REDIS.hincrby "user:1:tallies", "category:#{skill.category}", -1
      
      mask.conditions(skill).each do |condition|
        # Condition Tallies
        REDIS.hincrby "user:1:tallies", "skill:#{skill.id}:condition:#{condition.id}", -1
        REDIS.hincrby "user:1:tallies", "condition:#{condition.id}", -1
        
        REDIS.lpop "user:1:performance:#{skill.id}" # Skill performance
      end
      
      REDIS.lpop    "user:1:difficulty:#{skill.id}" # Difficulty
      REDIS.lpop    "user:1:points:#{skill.id}"     # Points
    end
  end
end
