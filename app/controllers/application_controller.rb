class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

  def fetch_patient
    @patient = PatientPresenter.new(Patient.find(params[:patient_id]))
  end

  def page
    params.fetch(:page, 1)
  end

  def query
    params[:query]
  end

  def referer_location
    session[:referer_location]
  end

  def store_referer_location
    session[:referer_location] = request.original_url
  end

  def delete_referer_location
    session.delete(:referer_location) if session[:referer_location]
  end
end
