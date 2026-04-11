module API
  class PatientsController < BaseController
    EDITABLE_FIELDS = %w[
      first_name last_name birthdate identity_card_number
      address phone_number email profession health_insurance
      gender civil_status source
    ].freeze

    def index
      patients = Patient.kept.search(params[:query]).limit(40)
      render json: { suggestions: patients.map { |p| PatientResource.new(p).to_h } }
    end

    def update
      patient = Patient.find(params[:id])

      unless EDITABLE_FIELDS.include?(params[:name])
        return render json: { error: 'Field not editable' }, status: :unprocessable_content
      end

      patient.update!(params[:name] => params[:value])
      render json: { value: params[:value] }, status: :ok
    end

    def consent
      patient = Patient.find(params[:id])
      patient.update!(data_management_consent: params[:consent])
      render json: { consent: patient.data_management_consent }, status: :ok
    end
  end
end
