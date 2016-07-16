require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:others_answer) { create(:answer, question: question, user: create(:user)) }

  subject(:post_answer) { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }
  subject(:post_invalid_answer) { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
  subject(:patch_answer) { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
  subject(:destroy_answer) { delete :destroy, question_id: question, id: answer, format: :js }
  subject(:patch_star_answer) { patch :star, id: answer, question_id: question, format: :js }
  subject(:post_rate_inc) { post :rate_inc, id: others_answer, question_id: question, js: true }
  subject(:post_rate_dec) { post :rate_dec, id: others_answer, question_id: question, js: true }
  subject(:post_rate_revoke) { post :rate_revoke, id: answer, question_id: question, js: true }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'stores new Answer in the database' do
        expect { post_answer }.to change(Answer, :count).by(1)
      end

      it 'associates new Answer with correct Question' do
        expect { post_answer }.to change(question.answers, :count).by(1)
      end

      it 'associates new Answer with correct User' do
        expect { post_answer }.to change(@user.answers, :count).by(1)
      end

      it 'renders #create partial' do
        post_invalid_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t store the Answer' do
        expect { post_invalid_answer }.to_not change(Answer, :count)
      end

      it 'renders to #create partial' do
        post_invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'own answer' do
      it 'assigns answer to edit to @answer' do
        patch_answer
        answer.reload

        expect(assigns(:answer)).to eq answer
      end

      it 'answer assigned to @answer do belongs to correct question' do
        patch_answer
        answer.reload

        expect(assigns(:answer).question).to eq question
      end

      it 'changes answer attributes' do
        edited_body = Faker::Lorem.paragraph(4, true, 8)

        patch :update, id: answer, question_id: question, answer: {body: edited_body}, format: :js
        answer.reload

        expect(answer.body).to eq edited_body
      end

      it 'doesn\'t change user the answer belongs to' do
        @alt_user = create(:user)
        edited_body = Faker::Lorem.paragraph(4, true, 8)

        patch :update, id: answer, question_id: question, answer: {body: edited_body}, user: @alt_user, format: :js
        answer.reload

        expect(answer.user).not_to eq @alt_user
      end

      it 'renders #update partial' do
        patch_answer
        answer.reload
        expect(response).to render_template :update
      end
    end

    context 'other user\'s answer' do
      before { @alt_answer = create(:answer, question: question, user: create(:user)) }

      it 'doesn\'t change answer attributes' do
        edited_body = Faker::Lorem.paragraph(4, true, 8)
        patch :update, id: @alt_answer, question_id: question, answer: {body: edited_body}, format: :js
        @alt_answer.reload

        expect(@alt_answer.body).to eq @alt_answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    context 'own answer' do
      it 'deletes the answer' do
        answer.reload
        expect { destroy_answer }.to change(Answer, :count).by(-1)
      end

      it 'renders #destroy partial' do
        destroy_answer
        expect(response).to render_template :destroy
      end
    end

    context 'other user\'s answer' do
      before { @alt_answer = create(:answer, question: question, user: create(:user)) }

      it 'doesn\'t delete answer' do
        expect { delete :destroy, question_id: question, id: @alt_answer, format: :js }.
            to change(Answer, :count).by(0)
      end

      it 'keeps answer in DB' do
        delete :destroy, question_id: question, id: @alt_answer, format: :js
        expect(Answer.exists?(@alt_answer.id)).to be true
      end
    end
  end

  describe 'PATCH #star' do
    let(:answer) { create(:answer, question: question, user: user, starred: false) }
    before { sign_in user }

    it 'assigns answer to star to @answer' do
      patch_star_answer
      answer.reload

      expect(assigns(:answer)).to eq answer
    end

    context 'own question' do
      it 'sets star flag for selected answer' do
        patch_star_answer
        answer.reload

        expect(answer.starred).to eq true
      end

      it 'cleans star flag for previously starred answer' do
        starred_answer = create(:answer, question: question, user: user, starred: true)

        patch_star_answer
        answer.reload
        starred_answer.reload

        expect(starred_answer.starred).to eq false
      end

      it 'renders #star partial' do
        patch_star_answer
        expect(response).to render_template :star
      end
    end

    context 'other user\'s question' do
      before do
        alt_user = create(:user)
        alt_question = create(:question, user: alt_user)
        @alt_answer = create(:answer, question: alt_question, user: user, starred: false)
        @alt_starred_answer = create(:answer, question: alt_question, user: user, starred: true)
        patch :star, id: @alt_answer, question_id: alt_question, format: :js
      end

      it 'doesn\'t sets star flag for selected answer' do
        expect(@alt_answer.starred).to eq false
      end

      it 'keeps star flag for already starred answer' do
        expect(@alt_starred_answer.starred).to eq true
      end
    end
  end

  describe 'POST #rate_inc' do
    it 'assigns @rateable to answer instance' do
      post_rate_inc
      expect(assigns(:rateable)).to eq answer
    end

    it 'changes rating for other users\' answers' do
      expect { post_rate_inc }.to change { others_answer.rating }.by(1)
    end

    it 'doesn\'t change rate for own answers' do
      expect { post :rate_inc, id: others_answer, js: true }
          .not_to change { answer.rating }
    end

    it 'responses with HTTP status 200' do
      post_rate_inc
      expect(response.status).to eq 200
    end
  end

  describe 'POST #rate_dec' do
    it 'assigns @rateable to answer instance' do
      post_rate_dec
      expect(assigns(:rateable)).to eq answer
    end

    it 'changes rating for other users\' answers' do
      expect { post_rate_dec }.to change { others_answer.rating }.by(-1)
    end

    it 'doesn\'t change rate for own answers' do
      expect { post :rate_dec, id: others_answer, js: true }
          .not_to change { answer.rating }
    end

    it 'responses with HTTP status 200' do
      post_rate_dec
      expect(response.status).to eq 200
    end
  end

  describe 'POST #rate_revoke' do
    before do
      @own_rate = create(:answer_rating, user: user, votable: answer)
      @others_rate = create(:answer_rating, user: create(:user), votable: answer)
    end

    it 'assigns @rateable to answer instance' do
      post_rate_revoke
      expect(assigns(:rateable)).to eq answer
    end

    it 'doesn\'t revoke rating for other users\' answers' do
      expect { post_rate_revoke }.not_to change { others_answer.rating }
    end

    it 'revokes rate for own answers' do
      expect { post :rate_revoke, id: answer, js: true }
          .to change { answer.rating }.by(-1)
    end

    it 'responses with HTTP status 200' do
      post_rate_revoke
      expect(response.status).to eq 200
    end
  end
end
