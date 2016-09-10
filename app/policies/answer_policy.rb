class AnswerPolicy < ApplicationPolicy
  include RateablePolicy

  def update?
    allow_owner
  end
end
