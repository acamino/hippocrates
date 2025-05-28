class AddDataManagementConsentToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :data_management_consent, :boolean, default: false, null: false
  end
end
