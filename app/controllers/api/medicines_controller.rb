module API
  class MedicinesController < ApplicationController
    def index
      medicines = Medicine.search(params[:query]).limit(40)
      render json: { suggestions: medicines.map(&serialize) }
    end

    private

    def serialize
      ->(medicine) { MedicineSerializer.new(medicine) }
    end
  end
end
