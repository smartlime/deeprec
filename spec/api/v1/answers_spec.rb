require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    include_examples(:unauthenticated) { let(:path) { "questions/#{question.id}/answers" } }

    context 'when authenticated' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }
      subject { response }

      it { is_expected.to be_success }

      context 'is a valid list of 2 Answers' do
        subject(:body) { response.body }

        include_examples :has_valid_json_object_at, nil, %w(id body created_at updated_at) do
          let!(:object) { answers }
        end
      end
    end
  end

  context "Answer members" do
    let(:answer) { create(:answer, question: question) }

    include_examples(:unauthenticated) { let(:path) { "answers/#{answer.id}" } }

    describe 'GET #show' do

      context 'when authenticated' do
        let!(:attachments) { [create(:answer_attachment, attachable: answer)] }
        let!(:comments) { [create(:comment, commentable: answer)] }

        before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }
        subject { response }

        it { is_expected.to be_success }

        context 'is a valid single Answer' do
          subject(:body) { response.body }

          include_examples :has_valid_json_object_at, nil, %w(id body created_at updated_at) do
            let!(:object) { answer }
          end

          context 'has valid Attachments' do
            include_examples :has_valid_json_object_at, 'answer', %w(id created_at updated_at) do
              let!(:object) { attachments }
            end

            it 'should have valid attribute "url"' do
              is_expected.to be_json_eql(attachments.first.file.url.to_json).at_path('answer/attachments/0/url')
            end
          end

          context 'has valid Comments' do
            include_examples :has_valid_json_object_at, 'answer', %w(id body created_at updated_at) do
              let!(:object) { comments }
            end
          end
        end
      end
    end

    describe 'POST #create' do
      context 'when authenticated' do
        context 'with valid attributes' do
          let(:create_answer) { post "/api/v1/questions/#{question.id}/answers", format: :json,
              access_token: access_token.token, answer: attributes_for(:answer) }

          it 'should store new Answer in the database' do
            expect { create_answer }.to change(Answer, :count).by(1)
          end

          describe 'JSON answer with new Answer' do
            before { create_answer }
            subject { response }

            it { is_expected.to be_success }

            context 'JSON answer has correct Answer' do
              let(:new_answer) { Answer.last }
              subject(:body) { response.body }

              %w(id body created_at updated_at).each do |attr|
                it { is_expected.to be_json_eql((new_answer).send(attr.to_sym).to_json).
                    at_path("answer/#{attr}") }
              end
            end
          end
        end

        context 'with invalid attributes' do
          let(:create_answer) { post "/api/v1/questions/#{question.id}/answers", format: :json,
              access_token: access_token.token, answer: attributes_for(:invalid_answer) }

          it 'shouldn\'t store new Answer in the database' do
            expect { create_answer }.to_not change(Answer, :count)
          end

          context 'response status' do
            before { create_answer }
            subject { response }

            it { is_expected.to be_unprocessable }
          end
        end

        context 'with other user\'s question' do
          let(:question) { create(:question, user: create(:user)) }
          let(:create_answer) { post "/api/v1/questions/#{question.id}/answers", format: :json,
              access_token: access_token.token, answer: attributes_for(:invalid_answer) }

          it 'shouldn\'t store new Answer in the database' do
            expect { create_answer }.to_not change(Answer, :count)
          end

          context 'response status' do
            before { create_answer }
            subject { response }

            it { is_expected.to be_unprocessable }
          end
        end
      end
    end
  end
end
