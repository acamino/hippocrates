class ChangeBirthdateToDateInPatients < ActiveRecord::Migration[8.1]
  def up
    change_column :patients, :birthdate, :date, null: false
  end

  def down
    change_column :patients, :birthdate, :timestamp, null: false
  end
end
