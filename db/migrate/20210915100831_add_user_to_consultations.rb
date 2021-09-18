class AddUserToConsultations < ActiveRecord::Migration[5.2]
  class User < ApplicationRecord
  end

  class Consultation < ApplicationRecord
  end

  def up
    add_reference :consultations, :user, foreign_key: { on_delete: :nullify }

    user = User.find_by(email: 'pdv_1orl@yahoo.es')
    Consultation.update_all(user_id: user.id)
  end

  def down
    remove_reference :consultations, :user, foreign_key: { on_delete: :nullify }
  end
end
