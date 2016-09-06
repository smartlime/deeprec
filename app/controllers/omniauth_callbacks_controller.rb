class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def facebook
  end

  def twitter
  end

  private

  def oauth
    auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(
        provider: session['oauth_provider'],
        uid: session['oauth_uid'],
        info: {email: params[:email]})
    if auth
      @user = User.find_for_oauth(auth)
      if @user.nil? && auth && auth.provider && auth.uid
        store_auth auth
        redirect_to account_confirm_email_path
      elsif @user&.persisted?
        set_flash_message :notice, :success, kind: auth.provider.to_s.capitalize if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      else
        failure_redirect
      end
    else
      failure_redirect
    end
  end

  def store_auth(auth)
    session['devise.oauth_provider'] = auth.provider
    session['devise.oauth_uid'] = auth.uid
  end

  def failure_redirect
    redirect_to new_user_registration_path, alert: 'Authentication failure'
  end
end
