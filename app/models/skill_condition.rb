class SkillCondition < ActiveRecord::Base
  belongs_to :skill
  belongs_to :condition
end
