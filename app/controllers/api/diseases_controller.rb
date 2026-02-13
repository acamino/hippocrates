module API
  class DiseasesController < ApplicationController
    def index
      diseases = Disease.select(:id, :code, :name).search(params[:query]).limit(40)
      render json: { suggestions: diseases.map(&serialize) }
    end

    private

    def serialize
      ->(disease) { DiseaseSerializer.new(disease) }
    end
  end
end
