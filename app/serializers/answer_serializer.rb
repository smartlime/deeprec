class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  def include_accociations?
    instance_options[:template] == 'show'
  end
end
