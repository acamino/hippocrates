class AddCompositeIndexesToConsultations < ActiveRecord::Migration[8.1]
  def change
    add_index :consultations, [:patient_id, :created_at, :id],
              order: { created_at: :desc, id: :desc },
              name: :idx_consultations_patient_created_id

    add_index :consultations, [:user_id, :created_at],
              order: { created_at: :desc },
              name: :idx_consultations_user_created
  end
end
