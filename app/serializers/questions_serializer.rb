class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :topic, :short_title, :body, :created_at, :updated_at

  def short_title; object.topic.truncate(10); end
end