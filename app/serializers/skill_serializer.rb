class SkillSerializer < ActiveModel::Serializer
  embed :ids, include: false
  
  has_many :conditions, key: :conditions
  has_many :restricted_conditions, key: :restricted_conditions
  
  attributes :id,
    :name,
    :category,
    :point_basis
   
end