module Admin
  class ChargesController < ApplicationController
    before_action :authorize_admin

    def index
      @consultations  = Consultation.by_date(date_range).by_user(uid).by_branch_office(bid).order_by_date.page(page)
      @total          = Consultation.by_date(date_range).by_user(uid).by_branch_office(bid).order_by_date.sum(:price)
      @users          = User.physician.order(:pretty_name)
      @branch_offices = BranchOffice.active.order(:active).order(:name)
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
