module API
  class DiseasesController < ApplicationController
    def index
      diseases = Disease.select(:id, :code, :name).search(params[:query]).limit(40)
      render json: { suggestions: diseases.map { |d| DiseaseResource.new(d).to_h } }
    end
  end
end
