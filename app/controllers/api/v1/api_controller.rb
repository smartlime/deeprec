class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :doorkeeper_authorize!

  respond_to :json

  protected

  def current_user
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
