module API
  class ConsultationsController < ApplicationController
    def last
      consultation = patient.consultations.last
      render json: consultation, include: [:diagnoses, :prescriptions]
    end

    def previous
      consultation = Consultation.find(previous_consultation_id)
      render json: consultation, include: [:diagnoses, :prescriptions]
    end

    def next
      consultation = Consultation.find(next_consultation_id)
      render json: consultation, include: [:diagnoses, :prescriptions]
    end

    private

    def previous_consultation_id
      patient_consultations[current_consultation_index.succ]
    end

    def next_consultation_id
      patient_consultations[current_consultation_index.pred]
    end

    def current_consultation_index
      patient_consultations.index(current_consultation)
    end

    def current_consultation
      params[:current_consultation].to_i
    end

    def patient
      Patient.find(params[:patient_id])
    end

    def patient_consultations
      @consultations ||= patient.consultations.pluck(:id).reverse
    end
  end
end
