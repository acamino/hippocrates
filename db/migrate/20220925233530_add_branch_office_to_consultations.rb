class AddBranchOfficeToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_reference :consultations, :branch_office, foreign_key: { on_delete: :nullify }
  end
end
