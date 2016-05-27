module API
  class DiseasesController < ApplicationController
    def index
      render json: Disease.all.map { |d| { value: d.name, data: d.code } }
    end
  end
end
