class TodoSerializer < ActiveModel::Serializer
  attributes :id, :name, :created
end
