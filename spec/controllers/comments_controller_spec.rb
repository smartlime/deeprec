require 'rails_helper'

shared_examples :commented do
  let(:comment_attributes) { attributes_for(:comment) }
  let(:post_comment) { post :create, commentable: commentable.entity.pluralize,
      "#{commentable.entity}_id": commentable.id,
      comment: comment_attributes, format: :js }
  let(:post_invalid_comment) { post :create, commentable: commentable.entity.pluralize,
      "#{commentable.entity}_id": commentable.id,
      comment: attributes_for(:invalid_comment), format: :js }

  describe 'POST #create' do
    sign_in_user

    it 'assigns @commentable' do
      post_comment
      expect(assigns(:commentable)).to eq commentable
    end

    context 'with valid attributes' do
      it 'stores Comment in the database and associates with correct Commetable' do
        expect { post_comment }.to change(commentable.comments, :count).by(1)
      end

      it 'associates Comment with correct User' do
        expect { post_comment }.to change(@user.comments, :count).by(1)
      end

      subject { post_comment }

      it { is_expected.to render_template :create }
    end

    context 'with invalid attributes' do
      it 'doesn\'t store Comment in the database' do
        expect { post_invalid_comment }.to_not change(Comment, :count)
      end

      subject { post_invalid_comment }
      it { is_expected.to render_template :create }
    end

    it_behaves_like :comet_publisher do
      let(:pub_channel) { '/comments' }
      let(:valid_request) { post_comment }
      let(:invalid_request) { post_invalid_comment }
      let(:valid_response_entry) { comment_attributes[:body] }
    end
  end
end

describe CommentsController do
  context 'Comments for Questions' do
    include_examples :commented do
      let(:commentable) { create(:question) }
    end
  end

  context 'Comments for Answers' do
    include_examples :commented do
      let(:commentable) { create(:answer) }
    end
  end
end
