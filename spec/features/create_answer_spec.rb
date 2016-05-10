require 'rails_helper'

feature 'User can give an answer to particular question', %(
  To be able to share my knowledge on topic
  As an anthenticated user
  I want to give an answer the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user can access new answer button and get the answer form' do
    sign_in user

    visit question_path(question)

    expect(page).to have_content question.topic
    expect(page).to have_content question.body
    expect(page).to have_content 'Дать свой ответ'

    click_on 'Дать свой ответ'

    expect(page).to have_content 'Ответить на вопрос'
    expect(page).to have_content question.topic
    expect(page).to have_content question.body
    expect(page).to have_content 'Ваш ответ:'
    expect(current_path).to eq new_question_answer_path(question)
    expect(find('#new_answer')).to have_content 'Отправить ответ'
  end

  scenario 'Authenticated user can create an answer' do
    sign_in user

    visit new_question_answer_path(question)

    fill_in 'Ваш ответ', with: Faker::Lorem.paragraph(4, true, 8)
    find('#new_answer').click_button('Отправить ответ')

    expect(find('.alert')).to have_content 'Ответ успешно размещен'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Unauthenticated user cannot access new answer button and get the answer form' do
    visit question_path(question)

    expect(page).not_to have_content 'Дать свой ответ'

    visit new_question_answer_path(question)

    expect(find('.alert')).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).not_to eq new_question_answer_path(question)
  end
end
