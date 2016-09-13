class ProfilePolicy < ApplicationPolicy
  def me?; user?; end
  def all?; user?; end
end
