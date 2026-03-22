module API
  class ConsultationsController < BaseController
    before_action :fetch_patient
    before_action :fetch_consultation, only: [:show]

    def show
      render json: { consultation: ConsultationSerializer.new(@consultation), meta: meta }
    end

    def destroy
      @patient.consultations.where(id: consultations_ids).discard_all
      render json: {}
    end

    private

    def fetch_patient
      @patient = Patient.find(params[:patient_id])
    end

    def fetch_consultation
      @consultation = @patient.consultations.includes(:diagnoses, :prescriptions).find(params[:id])
    end

    def consultations_ids
      params.fetch(:consultations, '').split('_').map(&:to_i)
    end

    def meta
      sql = <<~SQL.squish
        SELECT id, position, total, next_id, prev_id FROM (
          SELECT id,
            ROW_NUMBER() OVER (ORDER BY created_at DESC) as position,
            COUNT(*) OVER () as total,
            LAG(id) OVER (ORDER BY created_at DESC) as next_id,
            LEAD(id) OVER (ORDER BY created_at DESC) as prev_id
          FROM consultations
          WHERE patient_id = :patient_id AND discarded_at IS NULL
        ) windowed
        WHERE id = :consultation_id
      SQL

      row = ActiveRecord::Base.connection.select_one(
        ActiveRecord::Base.sanitize_sql([sql, patient_id: @patient.id, consultation_id: @consultation.id])
      )

      {
        total: row["total"].to_i,
        current: { id: row["id"], position: row["position"].to_i },
        previous: row["prev_id"] ? { id: row["prev_id"], position: row["position"].to_i + 1 } : nil,
        next: row["next_id"] ? { id: row["next_id"], position: row["position"].to_i - 1 } : nil
      }
    end
  end
end
