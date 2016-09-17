class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :attachments, if: :include_accociations?
  has_many :comments, if: :include_accociations?

  def include_accociations?
    instance_options[:template] == 'show'
  end
end
