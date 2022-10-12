module Admin
  class ChartsController < ApplicationController
    before_action :authorize_admin

    def index
      @users               = User.physician.order(:pretty_name)
      @branch_offices      = BranchOffice.active.order(:active).order(:name)
      @payments_chart      = Charts::Payments::Builder.new(date_range, uid, bid).call
      @consultations_chart = Charts::Consultations::Builder.new(date_range, uid, bid).call
    end

    private

    def uid
      params[:uid]
    end

    def bid
      params[:bid]
    end
  end
end
