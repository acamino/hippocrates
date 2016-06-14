module API
  class MedicinesController < ApplicationController
    def index
      render json: Medicine.all
    end
  end
end
