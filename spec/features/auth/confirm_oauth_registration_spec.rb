require 'features_helper'

shared_examples :oauth_registration_confirm do
  let(:email) { '1234@ab536356c.com' }

  background do
    clear_emails
    mock_auth_hash(provider, info: nil)
    visit new_user_session_path
    click_on "Sign in with #{provider.to_s.capitalize}"
    sleep 1
    fill_in 'Email', with: email
    click_on "Validate Email"
    sleep 1
    save_and_open_page
    puts '--------------------------------'
    p ActionMailer::Base.deliveries
    p all_emails
    p current_email
    open_email "test@example.com"
  end

  # scenario 'check email' do
  #   current_email.click_link 'Confirm my account'
  #   expect(page).to have_content 'Your email address has been successfully confirmed'
  # end
end

feature 'Confirm OAuth registration', %q(
  To became regular user
  As a guest having Facebook or Twitter account
  I want to set and confirm my email
) do

  [:facebook, :twitter].each do |prov|
    context "Logging in with #{prov.to_s.capitalize} OAuth" do
      given!(:provider) { prov }
      # given!(:identity) { create(:identity, provider: provider) }

      it_behaves_like :oauth_registration_confirm
    end
  end
end
