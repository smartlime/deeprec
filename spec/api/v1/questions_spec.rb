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

        include_examples :conform_common_json_api_format

        context 'is a Question' do
          it('should return Questions') { is_expected.to be_json_eql('"questions"').at_path('data/0/type') }
          it('should return array of 2 Questions') { is_expected.to have_json_size(2).at_path('data') }

          %w(topic body created_at updated_at).each do |attr|
            it { is_expected.to be_json_eql(question.send(attr.to_sym).to_json).
                at_path("data/0/attributes/#{attr.gsub('_', '-')}") }
          end

          it 'question object contains short_title' do
            is_expected.to be_json_eql(question.topic.truncate(10).to_json).at_path('data/0/attributes/short-title')
          end

          # context 'with an Answers' do
          #   it('should relate to Answers') { is_expected.to have_json_path('data/0/relationships/answers/data') }
          #   it('should relate to array of 1 Answers')  { is_expected.to have_json_size(1).at_path('data/0/relationships/answers/data') }
          #
          #   # include_examples :conform_common_json_api_format, 'data/0/relationships/answers'
          #
          #   %w(id body created_at updated_at).each do |attr|
          #     it { is_expected.to be_json_eql(answer.send(attr.to_sym).to_json).
          #         at_path("data/0/relationships/answers/data/0/#{fix_underscores(attr)}") }
          #   end
          # end
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
      end
    end
  end
end
