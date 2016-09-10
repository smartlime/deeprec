class AnswerPolicy < ApplicationPolicy
  def update?
    allow_owner
  end

  def rate?
    allow_user(user&.id != record.user_id)
  end

  def rate_revoke?
    allow_owner
  end
end
