class SessionSerializer < ActiveModel::Serializer
  embed :ids
  
  has_one :user, include: false
  
  attributes :id,
  :skills_encoded,
  :default_conditions_encoded

  def skills_encoded; object.skills; end
  def default_conditions_encoded; object.default_conditions; end
end