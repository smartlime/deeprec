class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :topic, :short_title, :body, :created_at, :updated_at

  has_many :answers, if: :include_accociations?
  has_many :attachments, if: :include_accociations?
  has_many :comments, if: :include_accociations?

  def short_title; object.topic.truncate(10); end

  def include_accociations?
    instance_options[:template] == 'show'
  end
end
