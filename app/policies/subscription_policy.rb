class SubscriptionPolicy < ApplicationPolicy
  def destroy?; create?; end
end
