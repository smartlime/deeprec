require 'rails_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  context 'Comments for Questions' do
    include_examples :commented do
      let(:commentable) { question }
      let(:post_commentable) { post :create, commentable: 'questions',
          question_id: question.id, comment: attributes_for(:comment), format: :js }
    end
  end
end
