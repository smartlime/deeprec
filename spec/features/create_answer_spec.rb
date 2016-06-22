require 'features_helper'

feature 'User can give an answer to particular question', %(
  To be able to share my knowledge on topic
  As an anthenticated user
  I want to give an answer the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user can access new answer button' do
    sign_in user

    visit question_path(question)

    expect(page).to have_content question.topic
    expect(page).to have_content question.body
    expect(find('#new_answer')).to have_content 'Send an Answer'
  end

  scenario 'Authenticated user can create an answer', js: true do
    sign_in user

    visit question_path(question)

    answer_text = Faker::Lorem.paragraph(4, true, 8)
    fill_in 'Your answer', with: answer_text
    find('#new_answer').click_button('Send an Answer')

    # expect(find('.alert')).to have_content 'Answer added.'
    expect(current_path).to eq question_path(question)

    within '#answers' do
      expect(page).to have_content answer_text
    end
  end

  scenario "Authenticated user cannot create invalid answer", js: true do
    sign_in user

    visit question_path(question)

    find('#new_answer').click_button('Send an Answer')

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Body is too short (minimum is 20 characters)'
  end

  # scenario 'Authenticated user can create an answer' do
  #   sign_in user
  #
  #   visit new_question_answer_path(question)
  #
  #   fill_in 'Your answer', with: Faker::Lorem.paragraph(4, true, 8)
  #   find('#new_answer').click_button('Send an Answer')
  #
  #   expect(find('.alert')).to have_content 'Answer added.'
  #   expect(current_path).to eq question_path(question)
  # end
  #
  scenario 'Unauthenticated user cannot access new answer button and get the answer form' do
    visit question_path(question)

    expect(page).not_to have_content 'Give an Answer'
  end
end
