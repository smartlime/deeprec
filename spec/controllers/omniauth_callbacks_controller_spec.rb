require 'rails_helper'

shared_examples :oauth_callback do
  let(:user) { create(:user) }
  before { request.env['devise.mapping'] = Devise.mappings[:user] }


  context 'empty request' do
    subject { get provider }
    it { is_expected.to redirect_to new_user_registration_path }
  end

  context 'email not given' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: provider.to_s, uid: '123456', info: {email: nil})
      get provider
    end

    it 'stores data in session' do
      expect(session['devise.oauth_provider']).to eq provider.to_s
      expect(session['devise.oauth_uid']).to eq '123456'
    end

    it { should_not be_user_signed_in }
    it { expect(response).to redirect_to account_confirm_email_path }
  end

  context 'user does not exist' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: provider.to_s, uid: '123456', info: {email: 'new-user@email.com'})
      get provider
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to be_a(User)
    end
    it 'expects to send confirmation email'
  end

  context 'nulled credentials' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: nil, uid: nil)
      get provider
    end

    it 'redirects to registration' do
      expect(response).to redirect_to new_user_registration_path
    end
  end
end

describe OmniauthCallbacksController do
  [:facebook, :twitter].each do |provider|
    describe "GET ##{provider}" do
      include_examples :oauth_callback do
        let(:provider) { provider }
      end
    end
  end
end
