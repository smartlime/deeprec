require 'rails_helper'

feature 'User can view questions index', %(
  To be able to see all the questions
  As a user
  I want to view the list of all questions
) do
  scenario 'User can view questions index' do
    questions = []
    5.times do
      questions.push Question.create(
        user: create(:user),
        topic: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph(4, true, 8))
    end

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.topic
    end
  end
end
