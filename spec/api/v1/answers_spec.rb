require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    let(:path) { api_v1_question_answers_path(question) }

    include_examples :unauthenticated, :get

    context 'when authenticated' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      subject(:body) { response.body }

      before { get path, format: :json, access_token: access_token.token }

      it { expect(response).to be_success }

      include_examples(:has_valid_json_object_at, nil, %w(id body created_at updated_at)) { let(:object) { answers } }
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }
    let(:path) { api_v1_answer_path(answer) }

    include_examples :unauthenticated, :get

    context 'when authenticated' do
      let!(:attachments) { [create(:answer_attachment, attachable: answer)] }
      let!(:comments) { [create(:comment, commentable: answer)] }
      subject(:body) { response.body }

      before { get path, format: :json, access_token: access_token.token }

      it { expect(response).to be_success }

      include_examples :has_valid_json_object_at, nil, %w(id body created_at updated_at) do
        let!(:object) { answer }
      end

      context 'has valid Attachments' do
        include_examples :has_valid_json_object_at, 'answer', %w(id created_at updated_at) do
          let!(:object) { attachments }
        end

        it 'has valid attribute "url"' do
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

  describe 'POST #create' do
    let(:path) { api_v1_question_answers_path(question) }

    include_examples :unauthenticated, :post

    context 'when authenticated' do
      context 'with valid attributes' do
        let(:create_answer) { post path, format: :json,
            access_token: access_token.token, answer: attributes_for(:answer) }

        it 'stores new Answer in the database' do
          expect { create_answer }.to change(Answer, :count).by(1)
        end

        describe 'JSON answer with new Answer' do
          before { create_answer }

          it { expect(response).to be_success }

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
        let(:create_answer) { post path, format: :json,
            access_token: access_token.token, answer: attributes_for(:invalid_answer) }

        it 'doesn\'t store new Answer in the database' do
          expect { create_answer }.to_not change(Answer, :count)
        end

        it_behaves_like('has unpocessable status') { let(:action) { create_answer } }
      end

      context 'with other user\'s question' do
        let(:question) { create(:question, user: create(:user)) }
        let(:create_answer) { post path, format: :json,
            access_token: access_token.token, answer: attributes_for(:invalid_answer) }

        it 'doesn\'t store new Answer in the database' do
          expect { create_answer }.to_not change(Answer, :count)
        end

        it_behaves_like('has unpocessable status') { let(:action) { create_answer } }
      end
    end
  end
end

