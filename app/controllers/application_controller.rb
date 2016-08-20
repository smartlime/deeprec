require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_js_current_user

  private

  def set_js_current_user
    gon.current_user = current_user
    gon.user_signed_in = user_signed_in?
  end
end
