require 'features_helper'

feature 'Check devise confirmation emails works' do
  background do
    # will clear the message queue
    clear_emails
    p Devise::Mailer.logger
    p Devise::Mailer.perform_deliveries
    p Devise::Mailer.delivery_method

    User.create(email: 'test@example.com', password: '123456')
    # Will find an email sent to test@example.com
    # and set `current_email`
    sleep 1
    p ActionMailer::Base.deliveries
    p all_emails
    open_email('test@example.com')
    p current_email
  end

  scenario 'following a link' do
    p all_emails
    # current_email.click_link 'your profile'
    # expect(page).to have_content 'Profile page'
  end
end
