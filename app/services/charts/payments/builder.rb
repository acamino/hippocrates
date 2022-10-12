module Charts
  module Payments
    class Builder
      def initialize(date_range, uid, bid)
        @date_range = date_range
        @uid        = uid
        @bid        = bid
      end

      def call
        [
          {
            name: 'Valores Pagados',
            data: payments.sum(:payment)
          },
          {
            name: 'Valores Pendientes',
            data: payments.sum(:pending_payment)
          }
        ]
      end

      private

      attr_reader :date_range, :uid, :bid

      def payments
        Consultation.unscoped
                    .by_date(date_range)
                    .by_user(uid)
                    .by_branch_office(bid)
                    .group_by_day(:created_at)
      end
    end
  end
end
