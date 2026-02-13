class AdminPolicy < ApplicationPolicy
  %i[index? show? create? update? destroy? export?].each do |action|
    define_method(action) { user.admin_or_super_admin? }
  end
end
