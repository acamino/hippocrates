module API
  class DiseasesController < ApplicationController
    def index
      render json: Disease.all
    end
  end
end
