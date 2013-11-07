class Session < ActiveRecord::Base
  include GameStats
  CHANGE_MEMORY = 2.week.ago
  belongs_to :user
  
  after_create    :process
  before_save     :needs_reprocessing?
  before_destroy  :reprocess_for_destroy
  
  def process(reverse: false)
    mask = Bitmask.new(skills)
    
    points      = 0
    difficulty  = 0
    
    mask.skills.each do |skill|
      skill_tally user, skill, reverse
      
      points      += skill.point_basis
      difficulty  += skill.difficulty
        
      mask.conditions(skill).each do |condition|
        condition_tally user, skill, condition, reverse
        
        skill_performance(user, skill, condition.point_basis, reverse) if condition.category == "performance"
        
        points      += condition.point_basis
        difficulty  += condition.difficulty
      end
      
      # calculate difficulty somehow
      difficulty_performance user, skill, difficulty, reverse
      
      # Points overall
      point_tally user, skill, points, reverse
    end
    
    # track improvement based on self-reported performance
    
    # achievement processing
    
    # get previous session, decide streak
    
    # TODO This shouldn't go here, probably?
    # Pusher.trigger("sessions", "session_processed", {message: "We processed your session and you got #{points} points! Amazzzssing!"}) if notify and Rails.env != "test"
  end
  def reprocess(delete: false)
    sessions  = self.class.where("created_at > ?", self.class::CHANGE_MEMORY).order("created_at ASC")
    index     = sessions.index(self)
    
    # reverse all relevant sessions, then reprocess in reverse order
    sessions[0..index].each { |session| session.process(reverse:true) }
    sessions[0..index].reverse.each do |session|
      session.process unless delete and self == session
    end
  end
  
  private
  def needs_reprocessing?
    self.reprocess if self.skills_changed? and not self.new_record?
  end
  def reprocess_for_destroy
    self.reprocess(delete: true)
  end
end
