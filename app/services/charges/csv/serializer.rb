module Charges
  module CSV
    class Serializer
      HEADERS = [
        'Sucrusal',
        'Usuario',
        'Paciente',
        'Valor Pagado',
        'Valor Pendiente',
        'Fecha'
      ].freeze

      def self.collection(consultations)
        ::CSV.generate(headers: true) do |csv|
          csv << HEADERS
          consultations.map { |consultation| new(consultation).call }.each do |consultation|
            csv << consultation
          end
        end
      end

      def initialize(consultation)
        @consultation = ConsultationPresenter.new(consultation)
      end

      def call
        [
          consultation.branch_office.name,
          consultation.doctor.pretty_name.upcase,
          consultation.patient.full_name,
          consultation.pretty_payment,
          consultation.pretty_pending_payment,
          consultation.created_at.strftime('%b %d, %Y %I:%M %p')
        ]
      end

      private

      attr_reader :consultation
    end
  end
end
