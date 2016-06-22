require 'features_helper'

feature 'Signing up', %(
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

    expect(page.find('.alert')).to have_content 'Welcome! You have signed up successfully.'
  end
end
