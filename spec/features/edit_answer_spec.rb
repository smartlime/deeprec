require 'features_helper'

feature 'User can edit own answer to any question', %(
  To be able to correct mistake in answer or provide an extra information
  As an anthenticated user
  I want to edit my own answer to any question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:alt_user) { create(:user) }
  given!(:alt_answer) { create(:answer, question: question, user: alt_user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    context 'for his own Answer to any Question' do
      scenario 'can access edit link' do
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'can edit Answer', js: true do
        edited_answer_body = Faker::Lorem.paragraph(4, true, 8)
        within "#answer-#{answer.id}" do
          click_on 'Edit'
          fill_in 'Answer', with: edited_answer_body
          click_on 'Save'

          expect(page).to have_content edited_answer_body
          expect(page).to_not have_content answer.body
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'cannot edit Answer with incorrect data', js: true do
        within "#answer-#{answer.id}" do
          click_on 'Edit'
          fill_in 'Answer', with: ''
          click_on 'Save'

          expect(page).to have_content 'Body can\'t be blank'
          expect(page).to have_content 'Body is too short'
          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario 'for other user\'s Answer to any Question cannot access edit link' do
      within "#answer-#{alt_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user cannot see link to edit any answer to any question' do
    visit question_path(question)

    within '#answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
