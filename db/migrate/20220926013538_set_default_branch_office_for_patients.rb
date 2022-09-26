class SetDefaultBranchOfficeForPatients < ActiveRecord::Migration[5.2]
  class BranchOffice < ApplicationRecord
  end

  class Patient < ApplicationRecord
  end

  def up
    default_branch_office = BranchOffice.create_with(active: true)
                                        .find_or_create_by(name: 'LATACUNGA')

    Patient.where(branch_office_id: nil).update_all(branch_office_id: default_branch_office.id)
  end

  def down
    Patient.where.not(branch_office_id: nil).update_all(branch_office_id: nil)
  end
end
