require 'features_helper'

feature 'Rate the Question', %q(
  To select the best Question
  As a User
  I want to rate other Users' Questions and revoke my votes
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated User' do
    before { visit questions_path }

    scenario 'Can see Question Rating' do
      within "#question-#{question.id}" do
        expect(page).to have_content 'Rating: '
      end
    end

    scenario 'Can rate other User\'s Question' do
      before do
        within "#question-#{question.id}" do
          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'
        end
      end

      scenario 'rate up', :js do
        within "#question-#{question.id}" do
          click_on 'Up'
          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'rate down', :js do
        within "#question-#{question.id}" do
          click_on 'Down'
          expect(page).to have_content 'Rating: -1'
        end
      end
    end


    scenario 'Cannot see links to rate other User\'s Question second time' do
      within "#question-#{question.id}" do
        click_on 'Up'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'Cannot see links to rate own Question' do
      alt_question = create(:question, user: user)
      visit questions_path

      within "#question-#{alt_question.id}" do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'Can revoke own vote and rate other Question', :js do
      alt_question = create(:question)
      visit questions_path

      within "#question-#{question.id}" do
        click_on 'Up'
        expect(page).to have_link 'Revoke'

        click_on 'Revoke'
      end

      within "#question-#{alt_question.id}" do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end
  end

  scenario 'Unauthenticated user cannot see links to rate the Question' do
    visit questions_path

    within '#questions' do
      expect(page).to have_content 'Rating: '
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end
end