class AddRecommendationsToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_column :consultations, :recommendations, :text
  end
end
