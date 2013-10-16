class AppSkillSerializer < ActiveModel::Serializer  
  root false
  
  attributes :id,
    :name,
    :category,
    :point_basis
    
end