class CreatePriceChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :price_changes do |t|
      t.belongs_to :consultation, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :user,         null: false, foreign_key: { on_delete: :cascade }

      t.decimal :previous_price,  null: false, default: 0.0
      t.decimal :updated_price,   null: false, default: 0.0
      t.text    :reason,          null: false

      t.timestamps                null: false
    end
  end
end
