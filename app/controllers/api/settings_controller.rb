module API
  class SettingsController < BaseController
    def index
      render json: Setting.all.map { |s| SettingResource.new(s).to_h }
    end

    def update
      authorize :admin, :update?
      setting = Setting.find(params[:id])

      if setting.update(value: params[:value])
        render json: SettingResource.new(setting).to_h
      else
        render json: setting.errors.messages[:value].first, status: :unprocessable_content
      end
    end
  end
end
