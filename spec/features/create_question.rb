require 'rails_helper'

feature 'User can create question', %(
  To be able to have ability to get answers
  As a user
  I want to ask a question
) do

  scenario 'User can access new question button and get the question form' do
    visit questions_path
    click_on 'Задать свой вопрос'

    expect(page).to have_content 'Задать свой вопрос'
    expect(page).to have_content 'Вопрос:'
    expect(current_path).to eq new_question_path
  end

  scenario 'User can create a question' do
    visit new_question_path
    fill_in 'Тема вопроса', with: Faker::Lorem.sentence
    fill_in 'Вопрос', with: Faker::Lorem.paragraph(4, true, 8)
    click_on 'Задать вопрос'

    expect(page.find('.alert')).to have_content 'Вопрос успешно задан'
  end

end
