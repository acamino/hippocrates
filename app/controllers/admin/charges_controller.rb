require 'axlsx'

module Admin
  class ChargesController < ApplicationController
    before_action :authorize_admin

    def export
      spreadsheet = Charges::Excel::Builder.call(consultations)
      send_data(spreadsheet.to_stream.read, download_options)
    end

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
      Charges::Searcher.call(uid, bid, date_range).order(created_at: :desc)
    end

    def uid
      params[:uid]
    end

    def bid
      params[:bid]
    end

    def download_options
      {
        type:        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        disposition: 'attachment',
        filename:    "payments_#{Time.zone.now.strftime('%Y_%m_%d_%H_%M_%S')}.xlsx"
      }
    end
  end
end
