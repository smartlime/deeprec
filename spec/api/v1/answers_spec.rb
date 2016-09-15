require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }

  describe 'GET /index' do
    include_examples(:unauthenticated) { let(:path) { "questions/#{question.id}/answers" } }

    context 'when authenticated' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'response body' do
        subject(:body) { response.body }

        include_examples :conform_common_json_api_format

        context 'is an Answer' do
          it('should return Answers') { is_expected.to be_json_eql('"answers"').at_path('data/0/type') }
          it('should return array of 2 Answers') { is_expected.to have_json_size(2).at_path('data') }

          %w(body created_at updated_at).each do |attr|
            it { is_expected.to be_json_eql(answer.send(attr.to_sym).to_json).
                at_path("data/0/attributes/#{attr.gsub('_', '-')}") }
          end
        end
      end
    end
  end
end
