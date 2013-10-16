class SessionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  has_one :user, include: false
  has_one :routine, include: false
  
  has_many :skills, key: :skills
  
  attributes :id,
    # :user_id,
    :is_template

end