class CreatePrescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :prescriptions do |t|
      t.references :consultation, foreign_key: true
      t.string :inscription,  null: false
      t.string :subscription, null: false

      t.timestamps            null: false
    end
  end
end
