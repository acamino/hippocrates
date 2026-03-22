module API
  class MedicinesController < ApplicationController
    def index
      medicines = Medicine.search(params[:query]).limit(40)
      render json: { suggestions: medicines.map { |m| MedicineResource.new(m).to_h } }
    end
  end
end
