class Session < ActiveRecord::Base
  belongs_to :user
  belongs_to :routine
  # has_many :skills

  has_many :session_tools
  has_many :tools, through: :session_tools
  
end
