class CreateAnamneses < ActiveRecord::Migration[5.1]
  def change
    create_table :anamneses do |t|
      t.references :patient, foreign_key: true
      t.string :personal_history
      t.string :surgical_history
      t.string :allergies
      t.string :observations
      t.string :habits
      t.string :family_history

      t.timestamps                      null: false
    end
  end
end
