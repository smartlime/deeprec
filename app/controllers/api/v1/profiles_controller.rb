class Api::V1::ProfilesController < Api::V1::ApiController
  def me
    authorize :profile
    respond_with current_user
  end

  def all
    authorize :profile
    respond_with User.all_except(current_user.id)
  end
end
