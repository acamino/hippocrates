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

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def meta
      ids      =  @patient.consultations.kept.order(created_at: :desc).pluck(:id)
      pages    =  ids.zip((ids.count..1).step(-1)).map do |id, position|
        { id: id, position: position }
      end
      current  =  pages.find { |page| page[:id] == @consultation.id }
      previous =  pages.find { |page| page[:position] == current[:position].pred }
      succ     =  pages.find { |page| page[:position] == current[:position].succ }

      {
        total: @patient.consultations.kept.count,
        current: current,
        previous: previous,
        next: succ
      }
    end
  end
end
