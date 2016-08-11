require 'features_helper'

feature 'Authenticated user can edit his own question', %q(
  To be able to correct mistake in answer or provide an extra information
  As an authenticated user
  I want to edit my question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:alt_user) { create(:user) }
  given!(:alt_question) { create(:question, user: alt_user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit questions_path
    end

    scenario 'can access edit link for his own question', :js do
      within "#question-#{question.id}" do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'can edit his own question with correct data', :js do
      edited_question = create(:question, user: user)
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Topic', with: edited_question.topic
        fill_in 'Question', with: edited_question.body
        click_on 'Save'

        expect(page).to have_content edited_question.topic
        expect(page).to_not have_content question.topic
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'cannot edit his own question with incorrect data', :js do
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Topic', with: ''
        fill_in 'Question', with: ''
        click_on 'Save'

        expect(page).to have_content 'Topic can\'t be blank'
        expect(page).to have_content 'Topic is too short'
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_content 'Body is too short'
        expect(page).to have_content question.topic
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'cannot access edit link for other user\'s question', :js do
      within "#question-#{alt_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user cannot see link to edit any question' do
    visit questions_path

    within '#questions' do
      expect(page).to_not have_link 'Edit'
    end
  end
end