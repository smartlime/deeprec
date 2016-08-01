require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }
  let(:others_question) { create(:question, user: other_user) }
  let(:own_rating) { create(:question_rating, user: user, rateable: question) }
  let(:others_rating) { create(:question_rating, user: other_user, rateable: others_question) }

  let(:post_question) { post :create, question: attributes_for(:question), format: :js }
  let(:post_invalid_question) { post :create, question: attributes_for(:invalid_question), format: :js }
  let(:patch_question) { patch :update, id: question, question: attributes_for(:question), format: :js }
  let(:destroy_question) { delete :destroy, id: question }
  let(:post_rate_inc) { post :rate_inc, id: others_question, format: :js }
  let(:post_rate_dec) { post :rate_dec, id: others_question, format: :js }
  let(:post_rate_revoke) { post :rate_revoke, id: question, format: :js }

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
        expect { post_question }.to change(Question, :count).by(1)
      end

      it 'associates new Question with correct User' do
        expect { post_question }.to change(@user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t store the question' do
        expect { post_invalid_question }.to_not change(Question, :count)
      end
    end

    it 'renders #create template' do
      post_invalid_question
      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'own Question' do
      it 'assigns question to edit to @question' do
        patch_question
        expect(assigns(:question)).to eq question
      end

      it 'Question assigned to @question do belongs to correct User' do
        patch_question
        expect(assigns(:question).user).to eq user
      end

      it 'changes Question attributes' do
        edited_question = create(:question, user: user)
        patch :update, id: question, question: {
            topic: edited_question.topic, body: edited_question.body}, format: :js
        question.reload
        expect(question.topic).to eq edited_question.topic
        expect(question.body).to eq edited_question.body
      end

      it 'doesn\'t change User the Question belongs to' do
        edited_question = create(:question, user: create(:user))
        patch :update, id: question, question: {
            topic: edited_question.topic, body: edited_question.body},
            user: edited_question.user, format: :js
        question.reload
        expect(question.user).not_to eq edited_question.user
      end

      it 'renders #update partial' do
        patch_question
        expect(response).to render_template :update
      end
    end

    context 'other user\'s Question' do
      before { @alt_question = create(:question, user: create(:user)) }

      it 'doesn\'t change Question attributes' do
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
        expect { destroy_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        destroy_question
        expect(response).to redirect_to questions_path
      end

      it 'shows :notice flash' do
        destroy_question
        expect(flash[:notice]).to be_present
      end
    end

    context 'other User\'s Question' do
      before { @alt_question = create(:question, user: create(:user)) }

      it 'doesn\'t delete Question' do
        expect { delete :destroy, id: @alt_question }.to change(Question, :count).by(0)
      end

      it 'keeps Question in DB' do
        delete :destroy, id: @alt_question
        expect(Question.exists?(@alt_question.id)).to be true
      end

      it 'redirects to not deleted Question' do
        delete :destroy, id: @alt_question
        expect(response).to redirect_to @alt_question
      end

      it 'shows :alert flash' do
        delete :destroy, id: @alt_question
        expect(flash[:alert]).to be_present
      end
    end
  end

  context 'Rateable' do
    before { sign_in user }

    describe 'POST #rate_inc' do
      it 'assigns @rateable to question instance' do
        post_rate_inc
        expect(assigns(:rateable)).to eq others_question
      end

      it 'changes rating for other users\' questions' do
        expect { post_rate_inc }
            .to change { others_question.rating }.by(1)
      end

      it 'doesn\'t change rate for own questions' do
        expect { post :rate_inc, id: others_question, js: true }
            .not_to change { question.rating }
      end

      it 'responses with HTTP status 200' do
        post_rate_inc
        expect(response.status).to eq 200
      end
    end

    describe 'POST #rate_dec' do
      it 'assigns @rateable to question instance' do
        post_rate_dec
        expect(assigns(:rateable)).to eq others_question
      end

      it 'changes rating for other users\' questions' do
        expect { post_rate_dec }
            .to change { others_question.rating }.by(-1)
      end

      it 'doesn\'t change rate for own questions' do
        expect { post :rate_dec, id: others_question, js: true }
            .not_to change { question.rating }
      end

      it 'responses with HTTP status 200' do
        post_rate_dec
        expect(response.status).to eq 200
      end
    end

    describe 'POST #rate_revoke' do
      before do
        own_rating
        others_rating
      end

      it 'assigns @rateable to question instance' do
        post_rate_revoke
        expect(assigns(:rateable)).to eq question
      end

      it 'doesn\'t revoke rating for other users\' questions' do
        expect { post_rate_revoke }
            .not_to change { others_question.rating }
      end

      it 'revokes rate for own questions' do
        expect { post :rate_revoke, id: question, js: true }
            .to change { question.rating }.by(-1)
      end

      it 'responses with HTTP status 200' do
        post_rate_revoke
        expect(response.status).to eq 200
      end
    end
  end
end