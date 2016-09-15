class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :topic, :body, :created_at, :updated_at

  has_many :answers
  has_many :attachments
  has_many :comments
end
