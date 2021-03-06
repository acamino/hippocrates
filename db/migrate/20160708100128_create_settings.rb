class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name,  null: false
      t.string :value, null: false

      t.timestamps           null: false
    end

    add_index :settings, :name, unique: true
  end
end
