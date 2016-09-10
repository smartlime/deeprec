class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    user and user.admin? || user == record.user
  end
end
