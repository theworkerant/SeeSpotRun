module Game
  module Modifiers
    extend ActiveSupport::Concern
  
    attr_accessor :new_skill_high_score
  
    def determine_skill_high_score(key, score)
      old = REDIS.get key
      self.new_skill_high_score = (!old.nil? and old.to_i < score)
    end
  end  
end
