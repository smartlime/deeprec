require 'rails_helper'

feature 'Signing out', %(
  To close current session
  As an authenticated user
  I want to sign out
) do

  given(:user) { create(:user) }

  scenario 'Registered authenticated user tries to sign in then sign out' do
    sign_in(user)

    expect(page.find('.alert')).to have_content 'Signed in successfully.'
    find(:xpath, "//a[@href='#{destroy_user_session_path}']").click
    expect(page.find('.alert')).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthotized user cannot view sign out link' do
    visit root_path

    expect {
      find(:xpath, "//a[@href='#{destroy_user_session_path}']")
    }.to raise_error(Capybara::ElementNotFound)
  end
end
