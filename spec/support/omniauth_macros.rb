module OmniauthMacros
  def mock_auth_hash(provider, oauth_params = {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
        {
            provider: provider,
            uid: '123545',
            info: {email: 'someuser@somehost.dom'}
            # 'user_info' => {
            #     'name' => 'mockuser',
            #     'image' => 'mock_user_thumbnail_url'
            # },
            # 'credentials' => {
            #     'token' => 'mock_token',
            #     'secret' => 'mock_secret'
            # }
        }.merge oauth_params)
  end
end
