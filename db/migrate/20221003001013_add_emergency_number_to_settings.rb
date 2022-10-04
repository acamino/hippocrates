class AddEmergencyNumberToSettings < ActiveRecord::Migration[6.1]
  class Setting < ApplicationRecord
  end

  def up
    Setting.find_or_create_by!(name: 'emergency_number') do |setting|
      setting.value = ''
    end
  end

  def down
    emergency_number = Setting.find_by(name: 'emergency_number')
    emergency_number&.destroy
  end
end
