module API
  class PatientsController < BaseController
    def index
      patients = Patient.kept.search(params[:query]).limit(40)
      render json: { suggestions: patients.map(&serialize) }
    end

    private

    def serialize
      ->(patient) { PatientSerializer.new(patient) }
    end
  end
end
