module Prescriptions
  # rubocop:disable Metrics/ClassLength
  class Printer
    BACKGROUND = "#{Rails.root}/public/templates/prescriptions/template.jpg".freeze

    DEFAULT_SERIAL = '00000'.freeze

    DOCUMENT_OPTIONS = {
      page_size: 'A4',
      page_layout: :landscape,
      background: BACKGROUND,
      background_scale: 0.12,
      bottom_margin: 20
    }.freeze

    DEFAULT_SIGNATURE_OPTIONS = {
      color: '1A4384',
      align: :center,
      style: :bold
    }.freeze

    PHONE_NUMBERS_OPTIONS = {
      font:  'Montserrat',
      color: '1E3463',
      style: :bold,
      size:  7
    }.freeze

    EMERGENCY_NUMBER_OPTIONS = {
      font:  'Montserrat',
      color: '1E3463',
      style: :bold,
      size:  8
    }.freeze

    WEBSITE_OPTIONS = {
      font:  'Montserrat',
      color: '1E3463',
      style: :bold,
      size:  10
    }.freeze

    FONT_FAMILIES = {
      'Montserrat' => {
        bold:   "#{Rails.root}/app/assets/fonts/Montserrat-Bold.ttf",
        normal: "#{Rails.root}/app/assets/fonts/Montserrat-Regular.ttf"
      }
    }.freeze

    def self.call(consultation, empty)
      emergency_number = Setting.emergency_number.value
      website          = Setting.website.value
      new(consultation, empty, emergency_number, website).call
    end

    def initialize(consultation, empty, emergency_number, website)
      @consultation     = consultation
      @empty            = empty
      @emergency_number = emergency_number
      @website          = website
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def call
      pdf = Prawn::Document.new(**DOCUMENT_OPTIONS)
      pdf.font_families.update(**FONT_FAMILIES)

      # Inscriptions
      Printers::Section.call(pdf, [233, 524], 136, phone_numbers, **PHONE_NUMBERS_OPTIONS)
      Printers::Section.call(pdf, [222, 505], 160, website, **WEBSITE_OPTIONS)
      Printers::Section.call(pdf, [300, 515], 136, emergency_number, **EMERGENCY_NUMBER_OPTIONS)
      Printers::Section.call(pdf, [-5,  474], 136, serial)
      Printers::Section.call(pdf, [244, 475], 136, location_and_date, align: :right)
      Printers::Section.call(pdf, [-26, 459], 405, patient_name)
      Printers::Section.call(pdf, [244, 442], 136, patient_age)
      Printers::Section.call(pdf, [-26, 442], 269, diagnoses, leading: 2)
      Printers::Section.call(pdf, [244, 426], 136, allergies, color: 'FF0000')
      Printers::Section.call(pdf, [-26, 385], 405, inscriptions) unless empty?

      # Signature
      Printers::Section.call(pdf, [80, 34], 200, doctor_name, **DEFAULT_SIGNATURE_OPTIONS)
      Printers::Section.call(pdf, [80, 24], 200, doctor_registration, **DEFAULT_SIGNATURE_OPTIONS)
      Printers::Section.call(pdf, [80, 14], 200, doctor_phone, **DEFAULT_SIGNATURE_OPTIONS)

      # Prescriptions
      Printers::Section.call(pdf, [651, 524], 136, phone_numbers, **PHONE_NUMBERS_OPTIONS)
      Printers::Section.call(pdf, [640, 505], 160, website, **WEBSITE_OPTIONS)
      Printers::Section.call(pdf, [718, 515], 136, emergency_number, **EMERGENCY_NUMBER_OPTIONS)
      Printers::Section.call(pdf, [415, 474], 136, serial)
      Printers::Section.call(pdf, [664, 475], 136, location_and_date, align: :right)
      Printers::Section.call(pdf, [395, 459], 405, patient_name)
      Printers::Section.call(pdf, [395, 385], 405, subscriptions) unless empty?
      Printers::Section.call(pdf, [393, 150], 405, warning_signs)
      Printers::Section.call(pdf, [393, 96],  405, recommendations)
      Printers::Section.call(pdf, [470, 29],  130, next_appointment)

      # Signature
      Printers::Section.call(pdf, [600, 34], 200, doctor_name, **DEFAULT_SIGNATURE_OPTIONS)
      Printers::Section.call(pdf, [600, 24], 200, doctor_registration, **DEFAULT_SIGNATURE_OPTIONS)
      Printers::Section.call(pdf, [600, 14], 200, doctor_phone, **DEFAULT_SIGNATURE_OPTIONS)

      # pdf.stroke_axis
      pdf.render_file('/tmp/prescription.pdf')
    end

    private

    attr_reader :consultation, :emergency_number, :website

    def empty?
      @empty
    end

    def doctor_name
      consultation.doctor.pretty_name
    end

    def doctor_registration
      "Reg. ACESS #{consultation.doctor.registration_acess}"
    end

    def doctor_phone
      consultation.doctor.phone_number.to_s
    end

    def serial
      consultation.serial || DEFAULT_SERIAL
    end

    def phone_numbers
      consultation.branch_office.phone_numbers
    end

    # Move to a presenter
    def location_and_date
      "Latacunga, #{consultation.created_at.strftime('%d/%m/%Y')}"
    end

    def patient
      @patient ||= consultation.patient
    end

    def patient_name
      "#{Prawn::Text::NBSP * 22}#{patient.full_name} (#{patient.identity_card_number})"
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
          medicine, *instructions = subscription.split(':')
          "<b>#{medicine.strip}</b>: #{instructions.join(':').strip}"
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
