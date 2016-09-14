require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    include_examples :unauthorized, :questions

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'response body' do
        subject(:body) { response.body }

        include_examples :conform_common_json_api_format

        context 'is a Question' do
          it('should return Questions') { is_expected.to be_json_eql('"questions"').at_path('data/0/type') }

          %w(topic body created_at updated_at).each do |attr|
            it { is_expected.to be_json_eql(question.send(attr.to_sym).to_json).
                at_path("data/0/attributes/#{attr.gsub('_', '-')}") }
          end

          context 'with an Answers' do
            it('should relate to Answers') { is_expected.to have_json_path('data/0/relationships/answers') }

            # include_examples :conform_common_json_api_format, 'data/0/relationships/answers'

            %w(id body created_at updated_at).each do |attr|
              it { is_expected.to be_json_eql(answer.send(attr.to_sym).to_json).
                  at_path("data/0/relationships/answers/data/0/#{fix_underscores(attr)}") }
            end
          end
        end
      end
    end
  end
end
