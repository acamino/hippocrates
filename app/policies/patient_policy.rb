class PatientPolicy < ApplicationPolicy
  def destroy?
    user.admin_or_super_admin? || user.doctor?
  end
end
