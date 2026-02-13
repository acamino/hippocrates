class PaymentChangePolicy < ApplicationPolicy
  def create?
    user.doctor? || user.admin_or_super_admin?
  end
end
