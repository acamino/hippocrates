module API
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    protected

    def render_not_found
      render json: '', status: :not_found
    end
  end
end
