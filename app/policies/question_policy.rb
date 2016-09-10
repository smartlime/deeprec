class QuestionPolicy < ApplicationPolicy
  include RateablePolicy

  def update?
    allow_owner
  end
end
