class AddBranchOfficeToPatients < ActiveRecord::Migration[5.2]
  def change
    add_reference :patients, :branch_office, foreign_key: { on_delete: :nullify }
  end
end
