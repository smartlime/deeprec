require 'features_helper'

feature 'User can edit own answer to any question', %(
  To be able to correct mistake in answer or provide an extra information
  As an anthenticated user
  I want to edit my own answer to any question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can access edit link for his own answer to any question' do
      within '#answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'can edit his own answer to any question', js: true do
      edited_answer_body = Faker::Lorem.paragraph(4, true, 8)
      click_on 'Edit'
      within '#answers' do
        fill_in 'Answer', with: edited_answer_body
        click_on 'Save'

        expect(page).to have_content edited_answer_body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'cannot edit his own answer to any question with incorrect data'
    scenario 'cannot access edit link for other user\'s answer to any question'
    scenario 'cannot edit other user\'s answer to any question'
    scenario 'cannot edit his own answer to any question with incorrect data'
  end

  scenario 'Unauthenticated user cannot edit any answer to any question' do
    visit question_path(question)

    within '#answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
