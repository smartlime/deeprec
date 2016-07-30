require 'features_helper'

feature 'Authenticated user can create question', %q(
  To be able to have ability to get answers
  As an authenticated user
  I want to ask a question
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user can access new question button and get the question form' do
    sign_in user

    visit questions_path

    click_on 'Ask a Question'

    expect(page).to have_content 'Ask a Question'
    expect(page).to have_content 'Question:'
    expect(current_path).to eq new_question_path
  end

  scenario 'Authenticated user can create a question', :js do
    sign_in user

    visit questions_path

    topic = Faker::Lorem.sentence
    body = Faker::Lorem.paragraph(4, true, 8)
    fill_in 'Question topic:', with: topic
    fill_in 'Question:', with: body
    find('#new_question').click_button('Ask Question')

    expect(current_path).to eq questions_path

    within '#questions' do
      expect(page).to have_content topic
    end

    expect(find_field('Question topic:')).to have_content ''
    expect(find_field('Question:')).to have_content ''
  end

  scenario 'Unauthenticated user cannot access new question button and new question form' do
    visit questions_path

    expect(page).not_to have_content 'Ask a Question'
    expect(page).not_to have_content 'Question:'

    visit new_question_path
    expect(find('.alert')).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
