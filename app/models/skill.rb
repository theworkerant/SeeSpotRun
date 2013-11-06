class Skill < ActiveRecord::Base
  has_many :skill_restricted_conditions
  has_many :restricted_conditions, through: :skill_restricted_conditions, source: :condition
  
  def restrictions
    mask = Bitwise.new
    mask_indexes = restricted_conditions.reduce([]) do |indexes,condition|
      indexes << Bitmask::CONDITION_IDS.index(condition.id)
    end
    mask.indexes = mask_indexes unless mask_indexes.empty?
    
    bits = mask.bits[0..Bitmask::BLANK_CONDITIONS_MASK.length-1] # trim first in case of spillover from Bitwise
    bits = bits + "0" until bits.length == Bitmask::BLANK_CONDITIONS_MASK.length
    
    bits.to_i(2).to_s(36)
  end
end
