class Skill < ActiveRecord::Base
  has_many :skill_restricted_conditions
  has_many :restricted_conditions, through: :skill_restricted_conditions, source: :condition
  
  def restrictions
    mask = Bitwise.new
    mask.bits = ::BLANK_CONDITIONS_MASK
    
    offset = ::BLANK_CONDITIONS_MASK.length - mask.bits.length
    restricted_conditions.each do |condition|
      mask.set_at(CONDITION_IDS.index(condition.id-offset))
    end
    mask.bits.to_i(2).to_s(36)
  end
end
