module OmniauthMacros
  def mock_auth_hash(provider, oauth_params = {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
        {
            provider: provider,
            uid: '123545'
        }.merge oauth_params)
  end
end
