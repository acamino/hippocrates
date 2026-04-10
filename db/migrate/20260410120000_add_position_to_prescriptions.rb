class AddPositionToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :prescriptions, :position, :integer, default: 0, null: false
  end
end
