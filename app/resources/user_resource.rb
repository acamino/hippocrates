# frozen_string_literal: true

class UserResource
  include Alba::Resource
  include Rails.application.routes.url_helpers

  attributes :data, :value, :path

  def data(user)
    user.id
  end

  def value(user)
    user.pretty_name.upcase
  end

  def path(user)
    edit_admin_user_path(user.id)
  end
end
