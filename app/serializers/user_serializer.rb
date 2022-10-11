class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id, key: :data
  attribute :value
  attribute :path

  def value
    object.pretty_name.upcase
  end

  def path
    edit_admin_user_path(object.id)
  end
end
