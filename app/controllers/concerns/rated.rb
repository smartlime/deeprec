module Rated
  extend ActiveSupport::Concern
  included do
    before_action :find_rateable, only: [:rate_inc, :rate_dec, :rate_revoke]
    before_action :protect_forbidden_rate, only: [:rate_inc, :rate_dec]
  end

  def rate_inc
    @rateable.change_rate!(1, current_user)
    render json: json_data(false)
  end

  def rate_dec
    @rateable.change_rate!(-1, current_user)
    render json: json_data(false)
  end

  def rate_revoke
    return head :forbidden unless current_user? || rate_exists?
    @rateable.revoke_rate!(current_user)
    render json: json_data(true)
  end

  private

  def json_data(revoked)
    {id: @rateable.id, rating: @rateable.rating, revoked: revoked}
  end

  def current_user?
    @rateable.user_id == current_user.id
  end

  def rate_exists?
    Rating.exists?(rateable: @rateable, user_id: current_user.id)
  end

  def find_rateable
    @rateable = controller_name.classify.constantize.find(params[:id])
  end

  def protect_forbidden_rate
    head :forbidden if current_user? || rate_exists?
  end
end