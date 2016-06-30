class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

  def page
    params.fetch(:page, 1)
  end

  def query
    params[:query]
  end
end
