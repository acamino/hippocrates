module Admin
  class ActivitiesController < ApplicationController
    before_action :authorize_admin

    def index
      start_date, end_date = date_range
      @activities = Activities::Searcher.call(params[:uid], start_date, end_date).page(page)
      @users      = User.active.order(:pretty_name)
    end

    private

    def date_range
      if params[:date_range].present?
        params[:date_range].split(' - ').map { |date| Date.parse(date) }
      else
        [Date.today, Date.today]
      end
    end
  end
end
