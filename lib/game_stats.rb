module GameStats
  LIST_STORAGE = 99
  def point_tally(user, skill, points, reverse=false)
    points = reverse ? points*-1 : points
    REDIS.hincrby "user:#{user.id}:tallies", "points", points
    REDIS.lpush "user:#{user.id}:points:#{skill.id}", points
    REDIS.ltrim "user:#{user.id}:points:#{skill.id}", 0, LIST_STORAGE
  end
  
  def skill_tally(user, skill, reverse=false)
    inc = reverse ? -1 : 1
    REDIS.hincrby "user:#{user.id}:tallies", "skill:#{skill.id}", inc
    REDIS.hincrby "user:#{user.id}:tallies", "category:#{skill.category}", inc
  end
  
  def condition_tally(user, skill, condition, reverse=false)
    inc = reverse ? -1 : 1
    REDIS.hincrby "user:#{user.id}:tallies", "skill:#{skill.id}:condition:#{condition.id}", inc
    REDIS.hincrby "user:#{user.id}:tallies", "condition:#{condition.id}", inc
  end
  
  def skill_performance(user, skill, points)
    REDIS.lpush "user:#{user.id}:performance:#{skill.id}", points
    REDIS.ltrim "user:#{user.id}:performance:#{skill.id}", 0, LIST_STORAGE*10 # assume ten times as many skills entryies as sessions
  end
    
  def difficulty_performance(user, skill, difficulty)
    REDIS.lpush "user:#{user.id}:difficulty:#{skill.id}", difficulty
    REDIS.ltrim "user:#{user.id}:difficulty:#{skill.id}", 0, LIST_STORAGE
  end  

end