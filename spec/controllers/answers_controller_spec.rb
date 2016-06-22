require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'stores new Answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.
          to change(Answer, :count).by(1)
      end

      it 'associates new Answer with correct Question' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.
          to change(question.answers, :count).by(1)
      end

      it 'associates new Answer with correct User' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.
          to change(@user.answers, :count).by(1)
      end

      it 'renders #create partial' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end

      # it 'shows :notice flash' do
      #   post :create, question_id: question.id, answer: attributes_for(:answer)
      #   expect(flash[:notice]).to be_present
      # end
    end

    context 'with invalid attributes' do
      it 'doesn\'t store the Answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }.
          to_not change(Answer, :count)
      end

      it 'renders to #create partial' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'own answer' do
      before { sign_in user }

      it 'deletes answer' do
        answer
        expect { delete :destroy, question_id: question, id: answer }.
          to change(Answer, :count).by(-1)
      end

      it 'redirects to question#show view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end

      it 'shows :notice flash' do
        delete :destroy, question_id: question, id: answer
        expect(flash[:notice]).to be_present
      end
    end

    context 'other user\'s answer' do
      before { sign_in user }
      before { @alt_answer = create(:answer, question: question, user: create(:user)) }

      it 'doesn\'t delete answer' do
        expect { delete :destroy, question_id: question, id: @alt_answer }.
          to change(Answer, :count).by(0)
      end

      it 'keeps answer in DB' do
        delete :destroy, question_id: question, id: @alt_answer
        expect(Answer.exists?(@alt_answer.id)).to be true
      end

      it 'redirects to question#show view' do
        delete :destroy, question_id: question, id: @alt_answer
        expect(response).to redirect_to question
      end

      it 'shows :alert flash' do
        delete :destroy, question_id: question, id: @alt_answer
        expect(flash[:alert]).to be_present
      end
    end
  end
end
