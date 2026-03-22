module API
  class PatientsController < BaseController
    def index
      patients = Patient.kept.search(params[:query]).limit(40)
      render json: { suggestions: patients.map { |p| PatientResource.new(p).to_h } }
    end
  end
end
