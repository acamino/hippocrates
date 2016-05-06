class ConsultationsController < ApplicationController
  def new
    @patient      = Patient.find(params[:patient_id])
    @consultation = Consultation.new
  end
end
