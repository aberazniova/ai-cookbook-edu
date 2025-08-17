class RecipePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    return true if user.admin?

    record.user == user
  end

  def create?
    true
  end

  def update?
    return true if user.admin?

    record.user == user
  end
end
