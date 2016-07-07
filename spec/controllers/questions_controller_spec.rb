require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all Questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders #index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 3, question: question) }

    before { get :show, id: question }

    it 'assings the requested Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'binds Attachments array to @answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'assigns new Answer for the Question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders #show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'binds Attachments array to @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders #new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'stores new Question in the database' do
        expect { post :create, question: attributes_for(:question) }.
            to change(Question, :count).by(1)
      end

      it 'associates new Question with correct User' do
        expect { post :create, question: attributes_for(:question) }.
            to change(@user.questions, :count).by(1)
      end

      it 'redirects to #show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:notice]).to be_present
      end

      it 'shows :notice flash' do
        post :create, question: attributes_for(:question)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t store the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.
            to_not change(Question, :count)
      end

      it 're-renders #new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'own question' do
      it 'assigns question to edit to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'question assigned to @question do belongs to correct user' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question).user).to eq user
      end

      it 'changes question attributes' do
        edited_question = create(:question, user: user)
        patch :update, id: question, question: {
            topic: edited_question.topic, body: edited_question.body}, format: :js
        question.reload
        expect(question.topic).to eq edited_question.topic
        expect(question.body).to eq edited_question.body
      end

      it 'doesn\'t change user the question belongs to' do
        edited_question = create(:question, user: create(:user))
        patch :update, id: question, question: {
            topic: edited_question.topic, body: edited_question.body},
              user: edited_question.user, format: :js
        question.reload
        expect(question.user).not_to eq edited_question.user
      end

      it 'renders #update partial' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'other user\'s question' do
      before { @alt_question = create(:question, user: create(:user)) }

      it 'doesn\'t change question attributes' do
        edited_question = create(:question, user: user)
        patch :update, id: @alt_question, question: {
            topic: edited_question.topic, body: edited_question.body}, format: :js
        @alt_question.reload
        expect(@alt_question.topic).to eq @alt_question.topic
        expect(@alt_question.body).to eq @alt_question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    context 'own question' do
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end

      it 'shows :notice flash' do
        delete :destroy, id: question
        expect(flash[:notice]).to be_present
      end
    end

    context 'other user\'s question' do
      before { @alt_question = create(:question, user: create(:user)) }

      it 'doesn\'t delete question' do
        expect { delete :destroy, id: @alt_question }.to change(Question, :count).by(0)
      end

      it 'keeps question in DB' do
        delete :destroy, id: @alt_question
        expect(Question.exists?(@alt_question.id)).to be true
      end

      it 'redirects to not deleted question' do
        delete :destroy, id: @alt_question
        expect(response).to redirect_to @alt_question
      end

      it 'shows :alert flash' do
        delete :destroy, id: @alt_question
        expect(flash[:alert]).to be_present
      end
    end
  end
end
