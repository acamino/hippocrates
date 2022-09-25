module Activities
  class Searcher
    def self.call(uid, start_date, end_date)
      new(uid, start_date, end_date).call
    end

    def initialize(uid, start_date, end_date)
      @uid        = uid
      @start_date = start_date
      @end_date   = end_date
    end

    def call
      Activity.by_date(date_range).by_owner(uid).ordey_by_date
    end

    private

    attr_reader :start_date, :end_date, :uid

    def date_range
      start_date.beginning_of_day..end_date.end_of_day
    end
  end
end
