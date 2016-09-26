require 'features_helper'

feature 'User can delete own question', %q(
  To delete unneeded question which I made
  As an authenticated user
  I want to delete a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated User' do
    before { sign_in user }

    scenario 'can delete own question' do
      visit question_path(question)
      find('#delete-question').click

      expect(find('.alert')).to have_content 'Question deleted.'
      expect(current_path).to eq questions_path
    end

    scenario 'can\'t delete other user\'s question' do
      question = create(:question, user: create(:user))

      visit question_path(question)

      expect(has_no_css?('#delete-question')).to be true
    end
  end


  scenario 'Unauthenticated user don\'t see delete question button' do
    visit question_path(question)

    expect(has_no_css?('#delete-question')).to be true
  end
end
