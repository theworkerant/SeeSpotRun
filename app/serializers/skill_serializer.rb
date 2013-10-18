class SkillSerializer < ActiveModel::Serializer
  root false
  embed :ids, include: false
  
  attributes :id,
    :name,
    :category,
    :point_basis,
    :difficulty,
    :restrictions
   
end