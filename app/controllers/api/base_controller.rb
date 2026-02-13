module API
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

    protected

    def render_not_found
      render json: '', status: :not_found
    end

    def render_forbidden
      render json: '', status: :forbidden
    end
  end
end
