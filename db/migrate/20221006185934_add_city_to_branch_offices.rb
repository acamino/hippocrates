class AddCityToBranchOffices < ActiveRecord::Migration[6.1]
  def change
    add_column :branch_offices, :city, :text
  end
end
