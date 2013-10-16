class Session < ActiveRecord::Base
  belongs_to :user
  belongs_to :routine

  has_many :session_skills
  has_many :skills, through: :session_skills
end
