module Charts
  module Consultations
    class Builder
      def initialize(date_range, uid, bid)
        @date_range = date_range
        @uid        = uid
        @bid        = bid
      end

      def call
        [
          {
            name: 'Consultas',
            data: consultations
          }
        ]
      end

      private

      attr_reader :date_range, :uid, :bid

      def consultations
        Consultation.unscoped
                    .by_date(date_range)
                    .by_user(uid)
                    .by_branch_office(bid)
                    .group_by_day(:created_at)
                    .count
      end
    end
  end
end
