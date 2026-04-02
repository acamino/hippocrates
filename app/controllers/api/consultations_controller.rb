module API
  class ConsultationsController < BaseController
    before_action :fetch_patient
    before_action :fetch_consultation, only: [:show]

    def show
      render json: { consultation: ConsultationResource.new(@consultation).to_h, meta: meta }
    end

    def destroy
      authorize Consultation
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
      row = fetch_meta_row

      {
        total: row['total'].to_i,
        current: { id: row['id'], position: row['position'].to_i },
        previous: meta_entry(row, 'prev_id', row['position'].to_i + 1),
        next: meta_entry(row, 'next_id', row['position'].to_i - 1)
      }
    end

    def meta_entry(row, key, position)
      row[key] ? { id: row[key], position: position } : nil
    end

    def fetch_meta_row # rubocop:disable Metrics/MethodLength
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

      params = { patient_id: @patient.id,
                 consultation_id: @consultation.id }
      ActiveRecord::Base.connection.select_one(
        ActiveRecord::Base.sanitize_sql([sql, params])
      )
    end
  end
end
