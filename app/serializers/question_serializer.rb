class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :topic, :short_title, :body, :created_at, :updated_at

  has_many :answers
  has_many :attachments
  has_many :comments

  def short_title; object.topic.truncate(10); end
end
