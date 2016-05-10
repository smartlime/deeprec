require 'rails_helper'

feature 'User can delete own answer', %(
  To delete unneeded answer which I made
  As an anthenticated user
  I want to delete an answer
) do
  given(:user) { create(:user) }
  given(:question_user) { create(:user) }
  given(:question) { create(:question, user: question_user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user can delete own answer' do
    sign_in user

    answer

    visit question_path(question)
    find("#delete-answer-#{answer.id}").click

    expect(find('.alert')).to have_content 'Ответ успешно удален.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authorized user can\'t see a button to delete other user\'s answer' do
    sign_in user

    answer = create(:answer, question: question, user: create(:user))

    visit question_path(question)

    expect { find("#delete-answer-#{answer.id}") }.to raise_error(Capybara::ElementNotFound)
  end

  scenario 'Unauthorized user don\'t see delete answer button' do
    visit question_path(question)

    expect { find("#delete-answer-#{answer.id}") }.to raise_error(Capybara::ElementNotFound)
  end
end
