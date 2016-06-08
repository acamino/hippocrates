class AddUniqueKeyIndexToDiseases < ActiveRecord::Migration
  def change
    add_index :diseases, :code, unique: true
  end
end
