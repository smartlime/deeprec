class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user || User::Guest.new
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    user?
  end

  def new?
    create?
  end

  def update?
    admin? || owner?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  protected

  def user?
    user.id > 0
  end

  def admin?
    user.admin?
  end

  def owner?(target = record)
    target.user_id == user.id
  end
end
