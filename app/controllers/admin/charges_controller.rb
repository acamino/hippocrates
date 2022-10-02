module Admin
  class ChargesController < ApplicationController
    before_action :authorize_admin

    def index
      @consultations  = Charges::Searcher.call(uid, bid, date_range).page(page)
      @total          = Charges::Searcher.call(uid, bid, date_range).sum(:price)
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
