require 'features_helper'

feature 'Signing up', %q(
  To give answers to the questions
  As an unregistered user
  I want to sign up
) do
  given(:password) { Faker::Internet.password }

  scenario 'New user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'

    expect(page.find('.alert')).to have_content Devise.allow_unconfirmed_access_for > 0 ?
        'Welcome! You have signed up successfully.' :
        'A message with a confirmation link has been sent to your email address.'
  end
end
