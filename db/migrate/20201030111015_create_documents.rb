class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :consultation, foreign_key: { on_delete: :cascade }
      t.text       :description,  null: false

      t.timestamps
    end
  end
end
