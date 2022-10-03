class AddAddressAndPhoneNumbersToBranchOffices < ActiveRecord::Migration[6.1]
  def change
    add_column :branch_offices, :address,        :text
    add_column :branch_offices, :phone_numbers,  :text
  end
end
