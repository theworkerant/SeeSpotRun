class SessionSkill < ActiveRecord::Base
  belongs_to :session
  belongs_to :skill
  
  has_many :skill_conditions, foreign_key: :skill_id, class_name: "SkillCondition"
  has_many :conditions, through: :skill_conditions
end
