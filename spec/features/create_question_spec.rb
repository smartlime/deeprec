require 'rails_helper'

feature 'Authenticated user can create question', %(
  To be able to have ability to get answers
  As an authenticated user
  I want to ask a question
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user can access new question button and get the question form' do
    sign_in user

    visit questions_path

    click_on 'Задать свой вопрос'

    expect(page).to have_content 'Задать свой вопрос'
    expect(page).to have_content 'Вопрос:'
    expect(current_path).to eq new_question_path
  end

  scenario 'Authenticated user can create a question' do
    sign_in user

    visit new_question_path

    fill_in 'Тема вопроса', with: Faker::Lorem.sentence
    fill_in 'Вопрос', with: Faker::Lorem.paragraph(4, true, 8)
    find('#new_question').click_button('Задать вопрос')

    expect(find('.alert')).to have_content 'Вопрос успешно задан'
    expect(current_path).to start_with '/questions/'
  end

  scenario 'Unauthenticated user cannot access new question button and new question form' do
    visit questions_path

    expect(page).not_to have_content 'Задать свой вопрос'
    expect(page).not_to have_content 'Вопрос:'

    visit new_question_path
    expect(find('.alert')).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
