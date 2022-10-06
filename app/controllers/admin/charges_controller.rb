module Admin
  class ChargesController < ApplicationController
    before_action :authorize_admin

    def index
      consultations   = Charges::Searcher.call(uid, bid, date_range)
      @consultations  = consultations.page(page)
      @total_paid     = consultations.sum(:payment)
      @total_pending  = consultations.sum(:pending_payment)
      @users          = User.physician.order(:pretty_name)
      @branch_offices = BranchOffice.active.order(:active).order(:name)
    end

    private

    def consultations
      Charges::Searcher.call(uid, bid, date_range)
    end

    def uid
      params[:uid]
    end

    def bid
      params[:bid]
    end
  end
end
