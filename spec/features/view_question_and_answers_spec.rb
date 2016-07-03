require 'features_helper'

feature 'User can view answers to particular question', %q(
  To be able to get information
  As a user
  I want to view the list of all the answers to particular question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User can view answers for particular question' do
    answers = []
    5.times do
      answers.push Answer.create(
          user: create(:user),
          question: question,
          body: Faker::Lorem.paragraph(4, true, 8)
      )
    end

    visit question_path(question.id)

    expect(page).to have_content question.topic
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
