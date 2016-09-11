class AnswerPolicy < ApplicationPolicy
  include RateablePolicy

  def update?
    allow_owner
  end

  def star?
    allow_user(user&.id == record.question.user_id)
  end
end
