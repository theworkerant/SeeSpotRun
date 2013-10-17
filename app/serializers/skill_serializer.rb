class SkillSerializer < ActiveModel::Serializer
  embed :ids, include: false
  
  has_many :conditions, key: :conditions
  
  attributes :id,
    :name,
    :category,
    :point_basis
   
end