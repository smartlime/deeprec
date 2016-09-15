class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
end