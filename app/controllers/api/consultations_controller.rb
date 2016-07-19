module API
  class ConsultationsController < BaseController
    def last
      consultation = patient.consultations.most_recent
      render json: consultation
    end

    def previous
      consultation = Consultation.find(previous_consultation_id)
      render json: consultation
    end

    def next
      consultation = Consultation.find(next_consultation_id)
      render json: consultation
    end

    def destroy
      consultations = Consultation.where(id: consultations_ids)
      consultations.delete_all

      render json: consultations
    end

    private

    def patient
      Patient.find(params[:patient_id])
    end

    def patient_consultations
      @consultations ||= patient.consultations.pluck(:id)
    end

    def previous_consultation_id
      patient_consultations[current_consultation_index.succ]
    end

    def next_consultation_id
      consultation_index = current_consultation_index.pred
      return nil if consultation_index < 0

      patient_consultations[consultation_index]
    end

    def current_consultation_index
      patient_consultations.index(current_consultation)
    end

    def current_consultation
      params[:current_consultation].to_i
    end

    def consultations_ids
      params.fetch(:consultations, '').split('_').map(&:to_i)
    end
  end
end
