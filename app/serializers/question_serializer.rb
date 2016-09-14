class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :topic, :body, :created_at, :updated_at

  has_many :answers
end
