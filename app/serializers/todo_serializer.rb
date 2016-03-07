class TodoSerializer < ActiveModel::Serializer
  attributes :id, :name, :completed, :created_time, :completed_time
end
