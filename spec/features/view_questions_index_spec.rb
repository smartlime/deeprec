require 'rails_helper'

feature 'User can view questions index', %(
  To be able to see all the questions
  As a user
  I want to view the list of questions
) do

  scenario 'User can view questions index' do
    @question1 = Question.create(topic: Faker::Lorem.sentence,
                                 body: Faker::Lorem.paragraph(4, true, 8))
    @question2 = Question.create(topic: Faker::Lorem.sentence,
                                 body: Faker::Lorem.paragraph(4, true, 8))

    visit questions_path

    expect(page).to have_content @question1.topic
    expect(page).to have_content @question1.topic
    expect(page).to have_content 'Задать свой вопрос'
  end

end
