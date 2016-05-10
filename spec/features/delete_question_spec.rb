require 'rails_helper'

feature 'User can delete own question', %(
  To delete unneeded question which I made
  As an anthenticated user
  I want to delete a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authorized user can delete own question' do
    sign_in user

    visit question_path(question)
    find('#delete-question').click

    expect(find('.alert')).to have_content 'Вопрос успешно удален.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authorized user can\'t delete other user\'s question' do
    question = create(:question, user: create(:user))

    sign_in user

    visit question_path(question)
    find('#delete-question').click

    expect(find('.alert')).to have_content 'Нельзя удалить чужой вопрос.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Unauthorized user don\'t see delete question button' do
    visit question_path(question)

    expect { find('#delete-question') }.to raise_error(Capybara::ElementNotFound)
  end
end
