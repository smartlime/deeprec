require 'features_helper'

feature 'User can give an answer to particular question', %q(
  To be able to share my knowledge on topic
  As an authenticated user
  I want to give an answer the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background { DatabaseCleaner.clean }

    describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can access new answer button' do
      expect(page).to have_content question.topic
      expect(page).to have_content question.body
      expect(find('#new_answer')).to have_content 'Send an Answer'
    end

    scenario 'can create an answer', :js do
      answer_text = Faker::Lorem.paragraph(4, true, 8)
      fill_in 'Your answer:', with: answer_text
      find('#new_answer').click_button('Send an Answer')

      expect(current_path).to eq question_path(question)

      within '#answers' do
        expect(page).to have_content answer_text
      end
      expect(find_field('Your answer:')).to have_content ''
    end

    scenario 'cannot create invalid answer', :js do
      find('#new_answer').click_button('Send an Answer')

      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to have_content 'Body is too short (minimum is 20 characters)'
    end
  end

  scenario 'Unauthenticated user cannot access new answer button and get the answer form' do
    visit question_path(question)

    expect(page).not_to have_content 'Give an Answer'
  end
end
