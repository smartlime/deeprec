require 'rails_helper'

feature 'User can delete own question', %(
  To delete unneeded question which I made
  As an anthenticated user
  I want to delete a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "Authorized user can delete own question" do
    sign_in user

    visit question_path(question)
    page.find('#delete-question').click

    expect(page.find('.alert')).to have_content 'Вопрос успешно удален.'
    expect(current_path).to eq questions_path
  end

  scenario "Authorized user cannot delete question of other user" do
    user_alt = create(:user)
    question = create(:question, user: user_alt)

    sign_in user

    visit question_path(question)
    page.find('#delete-question').click

    expect(page.find('.alert')).to have_content 'Нельзя удалить чужой вопрос.'
    expect(current_path).to eq question_path(question)
  end

  scenario "Unauthorized user cannot see delete question button" do
    visit question_path(question)

    expect { find('#delete-question') }.to raise_error(Capybara::ElementNotFound)
  end
end
