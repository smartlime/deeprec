require 'features_helper'


shared_examples :oauth_sign_in do
  given(:user) { create(:user) }

  context 'with email' do
    scenario 'do new registraion' do
      provider_name = provider.to_s.capitalize
      link_text = "Sign in with #{provider_name}"
      visit new_user_session_path
      expect(page).to have_link link_text
      mock_auth_hash(provider, {info: { email: user.email}})
      click_link link_text
      auth_success_text = "GLYPH:info-sign Successfully authenticated from #{provider_name} account."
      expect(page).to have_text auth_success_text
    end
  end
end

feature 'Signing in using OAuth', %q(
  To ask questions
  As a user
  I want to sign in using Facebook or Twitter
) do

  context 'Logging in with Facebook OAuth' do
    given!(:provider) { :facebook }
    given!(:identity) { create(:identity, provider: provider) }

    it_behaves_like :oauth_sign_in
  end

  # context 'Logging in with Twitter OAuth' do
  #   given(:provider) { :twitter }
  #   given!(:identity) { create(:identity, provider: provider) }
  #
  #   it_behaves_like :oauth_sign_in
  # end
end
