class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :document, foreign_key: { on_delete: :cascade }
      t.jsonb      :content_data

      t.timestamps
    end
  end
end
