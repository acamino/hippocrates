module Charges
  module Excel
    class Builder
      HEADERS = [
        'Sucrusal',
        'Usuario',
        'Paciente',
        'Valor Pagado',
        'Valor Pendiente',
        'Total (Pagado - Pendiente)',
        'Fecha'
      ].freeze

      def self.call(consultations, date_range)
        new(consultations, date_range).call
      end

      def initialize(consultations, date_range)
        @consultations = consultations
        @count         = consultations.count.next
        @date_range    = date_range
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def call
        package  = Axlsx::Package.new
        workbook = package.workbook
        styles   = workbook.styles
        currency = styles.add_style num_fmt: 7, alignment: { horizontal: :right }

        workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row HEADERS
          consultations.map(&present >> serialize).each do |consultation|
            sheet.add_row consultation
          end
          sheet.add_row [
            nil, nil, nil, "=SUM(D1:D#{count})", "=SUM(E1:E#{count})", "=SUM(F1:F#{count})", nil
          ]

          sheet.col_style 3, currency
          sheet.col_style 4, currency
          sheet.col_style 5, currency

          sheet.column_widths nil, nil, nil, 25, 25, 25, nil
        end
        package
      end

      private

      attr_reader :consultations, :count, :date_range

      def sheet_name
        dates = [date_range.first, date_range.last].map { |date| date.strftime('%Y-%m-%d') }
        "Cobros #{dates.join(' - ')}"
      end

      def present
        ->(consultation) { ConsultationPresenter.new(consultation) }
      end

      def serialize
        lambda { |consultation|
          [
            consultation.branch_office.name,
            consultation.doctor.pretty_name.upcase,
            consultation.patient.full_name,
            consultation.pretty_payment,
            consultation.pretty_pending_payment,
            consultation.pretty_total_payment,
            consultation.created_at.strftime('%b %d, %Y %I:%M %p')
          ]
        }
      end
    end
  end
end
