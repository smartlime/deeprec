require 'features_helper'

feature 'User can star the best answer to his question', %q(
  To be able to show others the best answer
  As an authenticated user
  I want to star any answer to my own question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    context 'for his own Answer to any Question' do
      scenario 'can access star button', :js do
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'Star'
        end
      end

      context 'clicking the star button when there\'s no starred answer' do
        before do
          within("#answer-#{answer.id}") { click_on 'Star' }
        end

        scenario 'can star any Answer', :js do
          within "#answer-#{answer.id}" do
            expect(page).to_not have_link 'Star'
            expect(page).to have_content answer.body
            expect(page).to have_content 'Best Answer:'
          end
        end
      end
    end

    scenario 'starred Answer is always at the top of Answers list', :js do
      second_answer = create(:answer, question: question, user: user)
      visit question_path(question)
      within("#answer-#{second_answer.id}") { click_on 'Star' }
      sleep 0.1
      within "#answers" do
        expect(page.first('div')).to have_content second_answer.body
      end
    end

    scenario 'can star any other answer if there starred answer is already exists', :js do
      alt_answer = create(:answer, question: question, user: user, starred: true)

      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on 'Star'
        expect(page).to_not have_link 'Star'
        expect(page).to have_content 'Best Answer:'
      end
    end

    scenario 'cannot see star button at answer to other user\'s question', :js do
      alt_user = create(:user)
      alt_question = create(:question, user: alt_user)
      alt_answer = create(:answer, question: alt_question, user: user)

      visit question_path(alt_question)
      alt_answer.reload

      within("#answer-#{alt_answer.id}") do
        expect(page).to_not have_link 'Star'
      end
    end
  end

  scenario 'Unauthenticated user cannot access star button for any answer to any question' do
    visit question_path(question)
    within "div#answers" do
      expect(page).to_not have_link 'Star'
    end
  end
end
