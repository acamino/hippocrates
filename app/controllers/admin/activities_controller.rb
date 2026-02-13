module Admin
  class ActivitiesController < ApplicationController
    before_action :authorize_admin_access

    def index
      @activities = Activities::Searcher.call(params[:uid], date_range).page(page)
      @users      = User.active.order(:pretty_name)
    end

    private

    def authorize_admin_access
      authorize :admin
    end
  end
end
