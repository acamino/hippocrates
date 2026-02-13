class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  def date_range
    if params[:date_range].present?
      start_date, end_date = params[:date_range].split(' - ').map { |date| Date.parse(date) }
      start_date.beginning_of_day..end_date.end_of_day
    else
      Date.today.beginning_of_day..Date.today.end_of_day
    end
  rescue Date::Error
    Date.today.beginning_of_day..Date.today.end_of_day
  end

  private

  def user_not_authorized
    redirect_to root_path, notice: 'Reservado para administradores'
  end
end
