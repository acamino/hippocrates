class AddIdToDiseases < ActiveRecord::Migration[5.2]
  def change
    add_column :diseases, :id, :primary_key
  end
end
