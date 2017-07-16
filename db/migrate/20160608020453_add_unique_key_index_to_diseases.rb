class AddUniqueKeyIndexToDiseases < ActiveRecord::Migration[5.1]
  def change
    add_index :diseases, :code, unique: true
  end
end
