require_relative '../../app/presenters/patient_presenter'

describe PatientPresenter do
  describe '.formatted_birthdate' do
    context 'when the patient is new' do
      it 'returns an empty string' do
        patient = double(:patient, new_record?: true)
        patient_presenter = described_class.new(patient)
        expect(patient_presenter.formatted_birthdate).to be_empty
      end
    end

    context 'when the patient already exists' do
      it 'returns a formatted date' do
        patient = double(:patient, new_record?: false,
                                   birthdate: Date.new(2017, 7, 12))
        patient_presenter = described_class.new(patient)
        expect(patient_presenter.formatted_birthdate).to eq('2017-07-12')
      end
    end
  end
end
