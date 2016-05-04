require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do

    context 'with valid attributes' do
      xit 'stores new answer in the database' do
        expect { post :create, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

    end

    context 'with invalid attributes' do
      xit 'doesn\'t store the question'
    end

    xit 'redirects to show Questions view' do
      expect(response).to redirect_to question_answers_path(assigns(:question))
    end
  end
end
