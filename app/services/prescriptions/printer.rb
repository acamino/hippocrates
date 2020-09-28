module Prescriptions
  class Printer
    BACKGROUND = "#{Rails.root}/public/templates/prescriptions/template.jpg".freeze

    DOCUMENT_OPTIONS = {
      page_size: 'A4',
      page_layout: :landscape,
      background: BACKGROUND,
      background_scale: 0.12
    }.freeze

    def self.call(consultation)
      new(consultation).call
    end

    def initialize(consultation)
      @consultation = consultation
    end

    # rubocop:disable AbcSize
    # rubocop:disable MethodLength
    def call
      pdf = Prawn::Document.new(**DOCUMENT_OPTIONS)
      Printers::Section.call(pdf, [244, 463], 136, location_and_date, align: :right)
      Printers::Section.call(pdf, [-26, 442], 269, patient_name)
      Printers::Section.call(pdf, [244, 443], 136, patient_age)
      Printers::Section.call(pdf, [-26, 426], 269, diagnoses, leading: 2)
      Printers::Section.call(pdf, [244, 426], 136, allergies)
      Printers::Section.call(pdf, [-26, 370], 405, inscriptions)

      Printers::Section.call(pdf, [664, 464], 136, location_and_date, align: :right)
      Printers::Section.call(pdf, [395, 442], 269, patient_name)
      Printers::Section.call(pdf, [395, 370], 405, subscriptions)
      Printers::Section.call(pdf, [393, 135], 405, warning_signs)
      Printers::Section.call(pdf, [393, 81],  405, recommendations)
      Printers::Section.call(pdf, [470, 14],  130, next_appointment)
      pdf.render_file('/tmp/prescription.pdf')
    end

    private

    attr_reader :consultation

    def document_options
      {
        page_size: 'A4',
        page_layout: :landscape,
        background: BACKGROUND,
        background_scale: 0.12
      }
    end

    # Move to a presenter
    def location_and_date
      "Latacunga, #{consultation.created_at.strftime('%d/%m/%Y')}"
    end

    def patient
      @patient ||= consultation.patient
    end

    def patient_name
      "#{Prawn::Text::NBSP * 22}#{patient.full_name}"
    end

    def patient_age
      computed_age = AgeCalculator.calculate(patient.birthdate)
      "#{Prawn::Text::NBSP * 15}#{computed_age.years} AÑOS #{computed_age.months} MESES"
    end

    def diagnoses
      formatted_diagnoses = consultation.diagnoses.map do |d|
        "#{d.disease_code.strip} #{d.description.strip}"
      end.join(', ')

      "#{Prawn::Text::NBSP * 42}#{formatted_diagnoses}"
    end

    def allergies
      "#{Prawn::Text::NBSP * 21}<b>#{patient.anamnesis.allergies}</b>"
    end

    def prescriptions
      @prescriptions ||= consultation.prescriptions
    end

    def inscriptions
      consultation.prescriptions.map(&:inscription).map(&:strip).join("\n\n")
    end

    def subscriptions
      prescriptions.map(&:subscription)
                   .map(&formatted_subscription)
                   .join("\n\n")
    end

    def formatted_subscription
      lambda do |subscription|
        if subscription.include?(':')
          medicine, instructions = subscription.split(':')
          "<b>#{medicine.strip}</b>: #{instructions.strip}"
        else
          subscription
        end
      end
    end

    def warning_signs
      consultation.warning_signs
    end

    def recommendations
      consultation.recommendations || ''
    end

    def next_appointment
      consultation&.next_appointment&.strftime('%d-%m-%Y') || ''
    end
  end
end
