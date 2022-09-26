class CreateBranchOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :branch_offices do |t|
      t.text    :name,   null: false
      t.boolean :main,   null: false, default: false
      t.boolean :active, null: false, default: true

      t.timestamps       null: false
    end

    add_index :branch_offices, :name, unique: true
  end
end
