class AppSkillSerializer < ActiveModel::Serializer  
  root false
  embed :ids, include: false
  
  has_many :restricted_conditions, key: :restricted_conditions
  
  attributes :id,
    :name,
    :category,
    :point_basis
    
end