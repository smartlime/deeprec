require 'features_helper'

feature 'Signing in', %q(
  To ask questions
  As a user
  I want to sign in
) do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in user

    expect(find('.alert')).to have_content 'Signed in successfully.'
  end

  scenario 'Not registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'someotheruser@homehost.dom'
    fill_in 'Password', with: 'imaginary-password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
