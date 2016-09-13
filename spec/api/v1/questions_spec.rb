require 'rails_helper'

shared_examples :unauthorized do |method|
  context 'when not authorized' do
    context 'status when no access_token' do
      subject { get "/api/v1/#{method.to_s}", format: :json }
      it { is_expected { response.status }.to be 401 }
    end

    context 'status when access_token is invalid' do
      subject { get "/api/v1/#{method.to_s}", format: :json, access_token: '00000' }
      it { is_expected { response.status }.to be 401 }
    end
  end
end

describe 'Questions API' do
  describe 'GET /index' do
    include_examples :unauthorized, :questions

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question)}

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200' do
        p response.body
        expect(response).to be_success
      end

      it 'returns list' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id topic body created_at updated_at).each do |attr|
        it "Q object has #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in Q' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "A object has #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
