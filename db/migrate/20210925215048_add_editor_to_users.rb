class AddEditorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :editor, :boolean, null: false, default: false
  end
end
