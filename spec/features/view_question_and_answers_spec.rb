require 'rails_helper'

feature 'User can view answers to particular question', %(
  To be able to get information
  As a user
  I want to view the list of answers to particular question
) do

  scenario 'User can view answers for particular question' do
    question = Question.create(topic: Faker::Lorem.sentence,
                                 body: Faker::Lorem.paragraph(4, true, 8))
    answer1 = Answer.create(question: question, body: Faker::Lorem.paragraph(4, true, 8))
    answer2 = Answer.create(question: question, body: Faker::Lorem.paragraph(4, true, 8))

    visit question_path(question.id)

    expect(page).to have_content question.topic
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
    expect(page).to have_content 'Дать свой ответ'
  end
end