class Skill < ActiveRecord::Base
  has_many :skill_conditions
  has_many :skill_restricted_conditions
  has_many :conditions, through: :skill_conditions
  has_many :restricted_conditions, through: :skill_restricted_conditions
end
