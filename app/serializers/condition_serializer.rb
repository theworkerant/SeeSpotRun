class ConditionSerializer < ActiveModel::Serializer  
  attributes :id,
    :name,
    :category,
    :point_basis,
    :difficulty
 
end