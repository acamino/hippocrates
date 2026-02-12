module API
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    protected

    def render_not_found
      render json: '', status: :not_found
    end

    def authorize_admin
      return if current_user.admin_or_super_admin?

      render json: '', status: :forbidden
    end

    def authorize_doctor_or_admin
      return if current_user.doctor? || current_user.admin_or_super_admin?

      render json: '', status: :forbidden
    end
  end
end
