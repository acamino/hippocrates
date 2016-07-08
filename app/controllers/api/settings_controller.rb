module API
  class SettingsController < ApplicationController
    def index
      render json: Setting.all
    end
  end
end
