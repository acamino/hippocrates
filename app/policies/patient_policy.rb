class PatientPolicy < ApplicationPolicy
  def destroy?
    user.admin_or_super_admin? || user.doctor? || user.can_delete_patients?
  end
end
