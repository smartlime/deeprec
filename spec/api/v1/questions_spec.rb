require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    include_examples :unauthenticated, :questions

    context 'when authenticated' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'is a valid list of 2 Questions' do
        subject(:body) { response.body }

        include_examples :has_valid_json_object_at, nil, %w(topic body created_at updated_at) do
          let!(:object) { questions }
          #before { @object = questions }
        end

        it 'showld have valid attribute "short_title"' do
          is_expected.to be_json_eql(question.topic.truncate(10).to_json).at_path('questions/0/short_title')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    include_examples(:unauthenticated) { let(:path) { "questions/#{question.id}" } }

    context 'when authenticated' do
      let!(:answers) { [create(:answer, question: question)] }
      let!(:attachments) { [create(:question_attachment, attachable: question)] }
      let!(:comments) { [create(:comment, commentable: question)] }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'is a valid single Question' do
        subject(:body) { response.body }

        include_examples :has_valid_json_object_at, nil, %w(id topic body created_at updated_at) do
          let!(:object) { question }
        end

        context 'has valid Answers' do
          include_examples :has_valid_json_object_at, 'question', %w(id body created_at updated_at) do
            let!(:object) { answers }
          end
        end

        context 'has valid Attachments' do
          _sb
          include_examples :has_valid_json_object_at, 'question', %w(id created_at updated_at) do
            let!(:object) { attachments }
          end

          it 'should have valid attribute "url"' do
            is_expected.to be_json_eql(attachments.first.file.url.to_json).at_path('question/attachments/0/url')
          end
        end

        context 'has valid Comments' do
          include_examples :has_valid_json_object_at, 'question', %w(id body created_at updated_at) do
            let!(:object) { comments }
          end
        end
      end
    end
  end
end
