module Game
  module Stats
    extend ActiveSupport::Concern
  
    LIST_STORAGE = 99
    def point_tally(user, skill, points, reverse=false)
      points = reverse ? (points * -1) : points
      REDIS.hincrby "user:#{user.id}:tallies", "points", points
      
      list_key = "user:#{user.id}:points:#{skill.id}"
      if reverse
        REDIS.lpop list_key
      else
        REDIS.lpush list_key, points
        REDIS.ltrim list_key, 0, LIST_STORAGE
      end
    end
  
    def skill_tally(user, skill, reverse=false)
      key = "user:#{user.id}:tallies"
      REDIS.hincrby key, "skill:#{skill.id}", tally_inc(reverse)
      REDIS.hincrby key, "category:#{skill.category}", tally_inc(reverse)
    end
  
    def condition_tally(user, skill, condition, reverse=false)
      key = "user:#{user.id}:tallies"
      REDIS.hincrby key, "skill:#{skill.id}:condition:#{condition.id}", tally_inc(reverse)
      REDIS.hincrby key, "condition:#{condition.id}", tally_inc(reverse)
    end
  
    def skill_performance(user, skill, points, reverse=false)
      list_key = "user:#{user.id}:performance:#{skill.id}"
      if reverse
        REDIS.lpop list_key
      else
        REDIS.lpush list_key, points
        REDIS.ltrim list_key, 0, LIST_STORAGE*10 # assume ten times as many skills entryies as sessions
      end
    end
    
    def difficulty_performance(user, skill, difficulty, reverse=false)
      list_key = "user:#{user.id}:difficulty:#{skill.id}"
      if reverse
        REDIS.lpop list_key
      else
        REDIS.lpush list_key, difficulty
        REDIS.ltrim list_key, 0, LIST_STORAGE
      end
    end
  
    def skill_high_score(user, skill, score, reverse=false)
      key = "user:#{user.id}:high_score:#{skill.id}"
      if reverse
        REDIS.set key, 0
      else
        determine_skill_high_score key, score
        REDIS.set key, score
      end
    end

    private
    def tally_inc(reverse)
      reverse ? -1 : 1
    end
  end  
end
