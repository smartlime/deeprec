require 'features_helper'

shared_examples :oauth_sign_in do
  given(:user) { create(:user) }
  given(:provider_name) { provider.to_s.capitalize }

  let(:link_text) { "Sign in with #{provider_name}" }
  let(:success_auth_text) { "GLYPH:info-sign Successfully authenticated from #{provider_name} account." }

  subject(:sign_in_with_oauth) do
    visit new_user_session_path
    expect(page).to have_link link_text
    click_link link_text
  end

  context 'when email is sent by OAuth provider' do
    scenario 'when User and Identity are new' do
      mock_auth_hash(provider, {info: {email: user.email}})
      sign_in_with_oauth

      expect(page).to have_content success_auth_text
    end

    scenario 'when User with given email is already registered' do
      mock_auth_hash(identity.provider, info: {email: user.email})
      sign_in_with_oauth

      expect(page).to have_content success_auth_text
      expect(page).not_to have_content 'Enter your email to proceed'
    end

    scenario 'when Identity is already registered with given email' do
      mock_auth_hash(identity.provider, uid: identity.uid, info: {email: identity.user.email})
      sign_in_with_oauth

      expect(page).to have_content success_auth_text
    end
  end

  context 'when no email is sent by OAuth provider' do
    context 'when User and Identity are new' do
      before do
        mock_auth_hash(provider, info: nil)
        sign_in_with_oauth

        expect(page).not_to have_content success_auth_text
        expect(page).to have_content 'Enter your email to proceed'
        expect(page).to have_button 'Validate Email'
      end

      scenario 'with new valid email' do
        fill_in 'Email', with: generate(:email)
        click_on 'Validate Email'

        expect(page).to have_content success_auth_text
      end

      scenario 'with email that already exists' do
        fill_in 'Email', with: user.email
        click_on 'Validate Email'

        expect(page).not_to have_content success_auth_text
        expect(page).to have_content 'GLYPH:alert Email already taken'
      end

      scenario 'with empty email' do
        click_on 'Validate Email'

        expect(page).not_to have_content success_auth_text
        expect(page).to have_content 'Form has an error(s)'
        expect(page).to have_content 'Email can\'t be blank'
      end

      scenario 'with invalid email' do
        fill_in 'Email', with: 'this_is_really_not_an_email'
        click_on 'Validate Email'

        expect(page).not_to have_content success_auth_text
        expect(page).to have_content 'Form has an error(s)'
        expect(page).to have_content 'Email is invalid'
      end
    end
  end

  scenario 'with invalid credentials' do
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
    sign_in_with_oauth

    expect(page).not_to have_content success_auth_text
    expect(page).to have_content 'GLYPH:alert Authentication failure'
  end

  scenario 'when User already logged in' do
    sign_in user

    visit new_user_session_path

    expect(page).not_to have_content success_auth_text
    expect(page).not_to have_link link_text
    expect(page).to have_content 'GLYPH:alert You are already signed in.'
  end
end

feature 'Signing in using OAuth', %q(
  To ask questions
  As a user
  I want to sign in using Facebook or Twitter
) do

  [:facebook, :twitter].each do |prov|
    context "Logging in with #{prov.to_s.capitalize} OAuth" do
      given!(:provider) { prov }
      given!(:identity) { create(:identity, provider: provider) }

      it_behaves_like :oauth_sign_in
    end
  end
end
