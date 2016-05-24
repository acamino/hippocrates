class CreateDiagnoses < ActiveRecord::Migration
  def change
    create_table :diagnoses do |t|
      t.references :consultation, foreign_key: true
      t.string     :disease_code
      t.string     :description, null: false
      t.integer    :type,        null: false, default: 0

      t.timestamps               null: false
    end

    add_foreign_key :diagnoses, :diseases, column: :disease_code, primary_key: :code
  end
end
