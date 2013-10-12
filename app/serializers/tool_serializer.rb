class ToolSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  attributes :id,
    :name,
    :point_basis

end