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

      context 'response body' do
        subject(:body) { response.body }

        context 'is a valid list of Questions' do
          it('should have root "questions" element') { is_expected.to have_json_path('questions') }
          it('should return array of 2 Questions') { is_expected.to have_json_size(2).at_path('questions') }

          %w(id topic body created_at updated_at).each do |attr|
            it { is_expected.to be_json_eql(question.send(attr.to_sym).to_json).
                at_path("questions/0/#{attr}") }
          end

          it 'question object contains short_title' do
            is_expected.to be_json_eql(question.topic.truncate(10).to_json).at_path('questions/0/short_title')
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    include_examples(:unauthenticated) { let(:path) { "questions/#{question.id}" } }

    context 'when authenticated' do
      let!(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:question_attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'response body' do
        subject(:body) { response.body }
        _sb

        include_examples :has_valid_json_object_at do
          let!(:object) { question }
        end

        context 'is a valid single Question' do
          it('should have root "question" element') { is_expected.to have_json_path('question') }

          %w(topic body created_at updated_at).each do |attr|
            it { is_expected.to be_json_eql(question.send(attr.to_sym).to_json).
                at_path("question/#{attr}") }
          end

          context 'with an Answers' do
            it('should return Answers') { is_expected.to have_json_path('question/answers') }
            it('should have an array of 1 Answers') { is_expected.to have_json_size(1).at_path('question/answers') }
            %w(id body created_at updated_at).each do |attr|
              it { is_expected.to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}") }
            end
          end
        end
      end
    end
  end
end
