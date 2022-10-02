module Charges
  class Searcher
    def self.call(uid, bid, date_range)
      new(uid, bid, date_range).call
    end

    def initialize(uid, bid, date_range)
      @uid        = uid
      @bid        = bid
      @date_range = date_range
    end

    def call
      Consultation.kept
                  .by_date(date_range)
                  .by_user(uid)
                  .by_branch_office(bid)
                  .order_by_date
    end

    private

    attr_reader :uid, :bid, :date_range
  end
end
