class AnswerPolicy < ApplicationPolicy
  include RateablePolicy

  def star?
    admin? || owner?(record.question)
  end
end
