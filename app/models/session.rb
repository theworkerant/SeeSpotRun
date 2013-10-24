class Session < ActiveRecord::Base
  CHANGE_MEMORY = 2.week.ago
  belongs_to :user
  
  def process(reprocess: false, notify: false)
    mask  = Bitmask.new(skills)
    
    Rails.logger.debug "should notify? #{notify} -- reprocess: #{reprocess} -- ##{self.id}"
    
    redis         = Redis.new(:host => "127.0.0.1", :port => 6379)
    list_storage  = 99
    
    points      = 143
    difficulty  = 5
    
    mask.skills.each do |skill|
      # Tallies
      redis.hincrby "user:1:tallies", "skill:#{skill.id}", 1
      redis.hincrby "user:1:tallies", "category:#{skill.category}", 1
        
      mask.conditions(skill).each do |condition|
        # Condition Tallies
        redis.hincrby "user:1:tallies", "skill:#{skill.id}:condition:#{condition.id}", 1
        redis.hincrby "user:1:tallies", "condition:#{condition.id}", 1
        
        # Skill performance
        redis.lpush "user:1:performance:#{skill.id}", condition.point_basis if condition.category == "performance"
        redis.ltrim "user:1:performance:#{skill.id}", 0, list_storage*10 # assume ten times as many skills entryies as sessions
      end
      
      # Difficulty
      # if reprocess
      #   difficulty_list = redis.lrange "user:1:difficulty:#{skill.id}", 0, list_storage
      #   redis.ltrim "user:1:difficulty:#{skill.id}", 1, 0 # killit
      #   difficulty_list.insert(index, difficulty+1)
      #   redis.lpush difficulty_list
      # else
        redis.lpush "user:1:difficulty:#{skill.id}", difficulty
        redis.ltrim "user:1:difficulty:#{skill.id}", 0, list_storage
      # end
      
      # Points overall
      redis.lpush "user:1:points:#{skill.id}", points
      redis.ltrim "user:1:points:#{skill.id}", 0, list_storage
      
    end
    
    # track improvement based on self-reported performance
    
    # achievement processing
    
    # get previous session, decide streak
    
    Pusher.trigger("sessions", "session_processed", {message: "We processed your session and you got #{points} points! Amazzzssing!"}) if notify
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
      redis.hincrby "user:1:tallies", "skill:#{skill.id}", -1
      redis.hincrby "user:1:tallies", "category:#{skill.category}", -1
      
      mask.conditions(skill).each do |condition|
        # Condition Tallies
        redis.hincrby "user:1:tallies", "skill:#{skill.id}:condition:#{condition.id}", -1
        redis.hincrby "user:1:tallies", "condition:#{condition.id}", -1
        
        redis.lpop "user:1:performance:#{skill.id}" # Skill performance
      end
      
      redis.lpop    "user:1:difficulty:#{skill.id}" # Difficulty
      redis.lpop    "user:1:points:#{skill.id}"     # Points
    end
  end
end
