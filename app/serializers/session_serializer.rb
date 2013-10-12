class SessionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  has_one :user, include: false
  has_one :routine, include: false
  
  # has_many :skills, key: :skills
  has_many :tools, key: :tools
  
  attributes :id,
    # :user_id,
    :duration,
    :distraction,
    :is_template

end