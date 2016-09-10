require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_js_current_user

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: exception.message if is_navigational_format?
  end

  protected

  def set_flash(scope, message)
    flash[scope] = message if is_navigational_format?
  end

  private

  def set_js_current_user
    gon.current_user = current_user
    gon.user_signed_in = user_signed_in?
  end
end
