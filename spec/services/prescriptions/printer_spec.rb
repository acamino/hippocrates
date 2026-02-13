require 'rails_helper'
require 'pdf/inspector'

Prawn::Fonts::AFM.hide_m17n_warning = true

RSpec.describe Prescriptions::Printer do
  let(:patient) { create(:patient_with_anamnesis) }
  let(:doctor) do
    create(:user, pretty_name: 'Dr. Smith', registration_acess: 'R12345',
                  phone_number: '555-1234')
  end
  let(:branch_office) do
    create(:branch_office, city: 'Guayaquil', phone_numbers: '04-555-0000')
  end
  let(:consultation) do
    create(:consultation, patient: patient, doctor: doctor,
                          branch_office: branch_office,
                          next_appointment: Date.new(2026, 3, 15),
                          warning_signs: 'Fever above 39C',
                          recommendations: 'Rest for 3 days')
  end

  let(:emergency_number) { '911' }
  let(:website) { 'www.clinic.com' }

  subject(:pdf_data) do
    described_class.new(consultation, empty, emergency_number, website).call
  end

  describe '#call' do
    let(:empty) { false }

    it 'returns a PDF binary string' do
      expect(pdf_data).to be_a(String)
      expect(pdf_data[0..3]).to eq('%PDF')
    end

    it 'includes the doctor name in the PDF' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('Dr. Smith')
    end

    it 'includes the patient name in the PDF' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include(patient.full_name)
    end

    it 'includes the doctor registration number' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('Reg. ACESS R12345')
    end

    it 'includes the branch office city' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('Guayaquil')
    end

    it 'includes warning signs' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('FEVER ABOVE 39C')
    end

    it 'includes recommendations' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('REST FOR 3 DAYS')
    end

    it 'includes the next appointment date' do
      text = extract_pdf_text(pdf_data)

      expect(text).to include('15-03-2026')
    end

    context 'with prescriptions' do
      before do
        consultation.prescriptions.create!(
          inscription: 'Amoxicillin 500mg',
          subscription: 'Amoxicillin: Take 1 every 8 hours'
        )
      end

      it 'includes the inscription' do
        text = extract_pdf_text(pdf_data)

        expect(text).to include('AMOXICILLIN 500MG')
      end

      it 'includes the subscription' do
        text = extract_pdf_text(pdf_data)

        expect(text).to include('AMOXICILLIN')
      end
    end

    context 'when empty is true' do
      let(:empty) { true }

      before do
        consultation.prescriptions.create!(
          inscription: 'Should not appear',
          subscription: 'Should not appear either'
        )
      end

      it 'still generates a valid PDF' do
        expect(pdf_data[0..3]).to eq('%PDF')
      end

      it 'omits inscriptions and subscriptions' do
        text = extract_pdf_text(pdf_data)

        expect(text).not_to include('Should not appear')
      end
    end
  end

  describe '.call' do
    before do
      create(:setting, :emergency_number)
      create(:setting, :website)
    end

    it 'fetches settings and delegates to an instance' do
      pdf_data = described_class.call(consultation, false)

      expect(pdf_data[0..3]).to eq('%PDF')
    end
  end

  private

  def extract_pdf_text(data)
    PDF::Inspector::Text.analyze(data).strings.join(' ')
  end
end
