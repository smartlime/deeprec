require 'rails_helper'

feature 'User can give an answer to particular question', %(
  To be able to share my knowledge on topic
  As an anthenticated user
  I want to give an answer the question
) do
  given(:user) { create(:user) }
  given(:question) do
    Question.create(
      topic: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph(4, true, 8))
  end

  before { sign_in user }

  scenario 'Authenticated user can access new answer button and get the answer form' do
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
    expect(page.find('#new_answer')).to have_content 'Отправить ответ'
  end

  scenario 'Authenticated user can create an answer' do
    visit new_question_answer_path(question)
    fill_in 'Ваш ответ', with: Faker::Lorem.paragraph(4, true, 8)
    page.find('#new_answer').click_button('Отправить ответ')

    expect(page.find('.alert')).to have_content 'Ответ успешно размещен'
    expect(current_path).to eq question_path(question)
  end
end
