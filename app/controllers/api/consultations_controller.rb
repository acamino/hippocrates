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
      scope = @patient.consultations.kept
      total = scope.count
      position = scope.where('created_at <= ?', @consultation.created_at).count

      prev_id = scope.where('created_at < ?', @consultation.created_at)
                     .reorder(created_at: :desc).limit(1).pluck(:id).first
      next_id = scope.where('created_at > ?', @consultation.created_at)
                     .reorder(created_at: :asc).limit(1).pluck(:id).first

      {
        total: total,
        current: { id: @consultation.id, position: position },
        previous: prev_id ? { id: prev_id, position: position - 1 } : nil,
        next: next_id ? { id: next_id, position: position + 1 } : nil
      }
    end
  end
end
