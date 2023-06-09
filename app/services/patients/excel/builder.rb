module Patients
  module Excel
    class Builder
      HEADERS = [
        'Historia Clínica',
        'Apellidos',
        'Nombres',
        'C.I.',
        'Fecha de nacimiento',
        'Sexo',
        'Estado Civil',
        'Dirección',
        'Teléfono',
        'Correo electrónico',
        'Referencia',
        'Audioprótesis',
        'Fecha de registro'
      ].freeze

      def self.call(patients, date)
        new(patients, date).call
      end

      def initialize(patients, date)
        @patients = patients
        @count    = patients.count.next
        @date     = date
      end

      # rubocop:disable Metrics/MethodLength
      def call
        package  = Axlsx::Package.new
        workbook = package.workbook

        workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row HEADERS
          patients.map(&present >> serialize).each do |patient|
            sheet.add_row patient
          end

          sheet.column_widths 20, 30, 30, 20, 20, 20, 20, 30, 30, 30, 20, 20, 20
        end
        package
      end

      private

      attr_reader :patients, :count, :date

      def sheet_name
        "Pacientes #{date.strftime('%Y-%m-%d')}"
      end

      def present
        ->(patient) { PatientPresenter.new(patient) }
      end

      def serialize
        lambda { |patient|
          [
            patient.medical_history,
            patient.last_name,
            patient.first_name,
            patient.identity_card_number,
            patient.birthdate.strftime('%Y/%m/%d'),
            patient.gender_es.upcase,
            patient.civil_status_es,
            patient.address,
            patient.phone_number,
            patient.email,
            patient.source_es.upcase,
            patient.hearing_aids_es,
            patient.created_at.strftime('%Y/%m/%d')
          ]
        }
      end
    end
  end
end
