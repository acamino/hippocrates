module Activities
  class Searcher
    def self.call(uid, date_range)
      new(uid, date_range).call
    end

    def initialize(uid, date_range)
      @uid        = uid
      @date_range = date_range
    end

    def call
      Activity.by_date(date_range)
              .by_owner(uid)
              .order_by_date
    end

    private

    attr_reader :date_range, :uid
  end
end
