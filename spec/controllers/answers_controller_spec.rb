require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Answer that belongs to right Question' do
      expect(assigns(:answer).question_id).to eq question.id
    end

    it 'renders #new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'stores new Answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.
            to change(Answer, :count).by(1)
      end

      it 'redirects to #show Questions view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t store the Answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.
            to_not change(Answer, :count)
      end

      it 're-renders #new view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end

  end
end
