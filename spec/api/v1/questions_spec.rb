require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  context "Question collection" do
    describe 'GET #index' do
      let(:path) { api_v1_questions_path }

      include_examples :unauthenticated, :get

      context 'when authenticated' do
        let!(:questions) { create_list(:question, 2) }
        let(:question) { questions.first }
        subject(:body) { response.body }

        before { get api_v1_questions_path, format: :json, access_token: access_token.token }

        it { expect(response).to be_success }

        include_examples :has_valid_json_object_at, nil, %w(id topic body created_at updated_at) do
          let!(:object) { questions }
        end

        it 'should have valid attribute "short_title"' do
          is_expected.to be_json_eql(question.topic.truncate(10).to_json).at_path('questions/0/short_title')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:path) { api_v1_question_path(question.id) }

    include_examples :unauthenticated, :get

    context 'when authenticated' do
      let!(:answers) { [create(:answer, question: question)] }
      let!(:attachments) { [create(:question_attachment, attachable: question)] }
      let!(:comments) { [create(:comment, commentable: question)] }
      subject(:body) { response.body }

      before { get path, format: :json, access_token: access_token.token }

      it { expect(response).to be_success }

      include_examples :has_valid_json_object_at, nil, %w(id topic body created_at updated_at) do
        let!(:object) { question }
      end

      context 'has valid Answers' do
        include_examples :has_valid_json_object_at, 'question', %w(id body created_at updated_at) do
          let!(:object) { answers }
        end
      end

      context 'has valid Attachments' do
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

  describe 'POST #create' do
    let(:path) { api_v1_questions_path }

    include_examples :unauthenticated, :post

    context 'when authenticated' do
      context 'with valid attributes' do
        let(:create_question) { post path, format: :json,
            access_token: access_token.token, question: attributes_for(:question) }

        it 'should store new Question in the database' do
          expect { create_question }.to change(Question, :count).by(1)
        end

        describe 'JSON answer with new Question' do
          before { create_question }

          subject(:body) { response.body }

          it { expect(response).to be_success }

          context 'JSON answer has correct Question' do
            let(:new_question) { Question.last }

            %w(id topic body created_at updated_at).each do |attr|
              it { is_expected.to be_json_eql((new_question).send(attr.to_sym).to_json).
                  at_path("question/#{attr}") }
            end
          end
        end
      end

      context 'with invalid attributes' do
        let(:create_question) { post path, format: :json,
            access_token: access_token.token, question: attributes_for(:invalid_question) }

        it 'shouldn\'t store new Question in the database' do
          expect { create_question }.to_not change(Question, :count)
        end

        it_behaves_like('has unpocessable status') { let(:action) { create_question } }
      end
    end
  end
end
