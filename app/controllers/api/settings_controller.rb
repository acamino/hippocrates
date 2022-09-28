module API
  class SettingsController < ApplicationController
    def index
      render json: Setting.all
    end

    def update
      setting = Setting.find(params[:id])

      if setting.update(value: params[:value])
        render json: setting
      else
        render json: setting.errors.messages[:value].first, status: :unprocessable_entity
      end
    end
  end
end
