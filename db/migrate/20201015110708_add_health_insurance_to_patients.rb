class AddHealthInsuranceToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :health_insurance, :text
  end
end
