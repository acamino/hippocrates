class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.integer  :medical_history,      null: false
      t.string   :last_name,            null: false, index: true
      t.string   :first_name,           null: false, index: true
      t.string   :identity_card_number, null: false, index: true
      t.datetime :birthdate,            null: false
      t.integer  :gender,               null: false, index: true, default: 0
      t.integer  :civil_status,         null: false, index: true, default: 0
      t.string   :address
      t.string   :profession
      t.string   :phone_number
      t.string   :email
      t.integer  :source,               null: false, index: true, default: 0

      t.timestamps                      null: false
    end
  end
end
