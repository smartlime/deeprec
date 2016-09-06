class AccountController < ApplicationController
  before_action :check_already_signed_in, only: [:confirm_email]
  before_action :check_oauth_in_session, only: [:confirm_email]

  def confirm_email
    if request.patch?
      email = params[:email]
      user = User.where(email: email).first
      provider = session['devise.oauth_provider']
      if user.present?
        set_flash :alert, 'Email already taken.'
      else
        User.transaction do
          @user = User.create(email: email, password: Devise.friendly_token[0, 20])
          if @user.persisted?
            @user.identities.create!({
                provider: provider,
                uid: session['devise.oauth_uid'].to_s})
          end
        end
        if @user.persisted?
          set_flash :notice, t(:success, kind: provider.to_s.capitalize)
          sign_in_and_redirect @user, event: :authentication
        end
      end
    end
  end

  private

  def check_already_signed_in
    redirect_to questions_path if signed_in?
  end

  def check_oauth_in_session
    if !session['devise.oauth_provider'] && !session['devise.oauth_uid']
      set_flash :notice, 'Registration done'
      redirect_to questions_path
    elsif !session['devise.oauth_provider'] || !session['devise.oauth_uid']
      session['devise.oauth_provider'] = nil
      session['devise.oauth_uid'] = nil
      set_flash :alert, 'Authentication error, try again'
      redirect_to new_user_session_path
    end
  end
end
