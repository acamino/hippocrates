module Notifications
  module Messages
    class Builder
      include ERB::Util

      def initialize(price_change)
        @price_change = price_change
      end

      def call
        [subject, content]
      end

      private

      attr_reader :price_change

      def subject
        "El precio de la consulta del paciente #{patient_name} del #{date} cambió"
      end

      def content
        [
          '<html><body>',
          "<p>El usuario #{h(user_name)} cambió el precio de la consulta ",
          "del paciente #{h(patient_name)} del #{h(date)} de #{h(previous_price)} a ",
          "#{h(updated_price)}.</p>",
          "<p>El motivo del cambio fue #{h(price_change.reason)}.</p>",
          '</body></html>'
        ].join
      end

      def user_name
        price_change.user.pretty_name.upcase
      end

      def patient_name
        price_change.consultation.patient.full_name.upcase
      end

      def date
        price_change.created_at.strftime('%b %d, %Y %I:%M %p')
      end

      def previous_price
        format('$%.2f', price_change.previous_price)
      end

      def updated_price
        format('$%.2f', price_change.updated_price)
      end
    end
  end
end
