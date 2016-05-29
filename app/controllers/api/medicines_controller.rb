module API
  class MedicinesController < ApplicationController
    def index
      render json: Medicine.all.map { |d| { value: d.name, data: d.instructions } }
    end
  end
end
