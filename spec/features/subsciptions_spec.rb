require 'rails_helper'

feature 'Authenticated User can (un)subscribe to any Question', %q(
  To be able to be notified about new Answers
  As an authenticated User
  I want to subscribe and unsubscribe to any Question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated User' do
    before { sign_in user }

    context 'as not a Question author' do
      scenario 'can subscribe if not subscribed', :js do
        visit question_path(question)

        expect(page).to have_button 'Subscribe'
        expect(page).not_to have_button 'Unubscribe'

        click_on 'Subscribe'

        expect(page).to have_button 'Unsubscribe'
        expect(page).not_to have_button 'Subscribe'
      end

      scenario 'can unsubscribe if subscribed', :js do
        create(:subscription, user: user, question: question)

        visit question_path(question)

        expect(page).not_to have_button 'Subscribe'
        expect(page).to have_button 'Unubscribe'

        click_on 'Unsubscribe'

        expect(page).not_to have_button 'Unsubscribe'
        expect(page).to have_button 'Subscribe'
      end
    end

    context 'as a Question author' do
      given!(:question) { create(:question, user: user) }

      scenario 'can unsubscribe', :js do
        visit question_path(question)

        expect(page).not_to have_button 'Subscribe'
        expect(page).to have_button 'Unubscribe'

        click_on 'Unsubscribe'

        expect(page).not_to have_button 'Unsubscribe'
        expect(page).to have_button 'Subscribe'
      end
    end
  end

  describe 'Unauthenticated User' do
    before { visit question_path(question) }

    scenario 'cannot subscribe' do
      expect(page).not_to have_button 'Subscribe'
    end

    scenario 'cannot unsubscribe' do
      expect(page).not_to have_button 'Unsubscribe'
    end
  end
end
