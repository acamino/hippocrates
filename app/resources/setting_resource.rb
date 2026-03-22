# frozen_string_literal: true

class SettingResource
  include Alba::Resource

  attributes :id, :name, :value
end
