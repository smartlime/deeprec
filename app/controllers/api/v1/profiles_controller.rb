class Api::V1::ProfilesController < Api::V1::ApiController
  def me
    respond_with current_resource_owner
  end

  def all
    respond_with User.all_except(current_resource_owner.id)
  end
end
