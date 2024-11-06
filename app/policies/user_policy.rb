class UserPolicy < AdminPolicy
  def show?
    record.id === user.id
  end

  def update?
    record.id === user.id
  end

  def destroy?
    user.admin? || record.id === user.id
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.none
    end
  end
end
