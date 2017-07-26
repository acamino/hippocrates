require 'i18n'
require_relative '../../app/presenters/consultation_presenter'

describe ConsultationPresenter do
  describe '#date' do
    it 'returns the consultation date' do
      consultation = double(:consultation, created_at: DateTime.new(2016, 1, 15))
      presenter = described_class.new(consultation)
      expect(presenter.date).to eq('2016-01-15')
    end
  end

  describe '#long_date' do
    it 'returns the consultation date' do
      consultation = double(:consultation, created_at: DateTime.new(2016, 1, 15))
      presenter = described_class.new(consultation)
      expect(presenter.long_date).to eq('Jan 15, 2016')
    end
  end

  describe '#time' do
    it 'returns the consultation time' do
      consultation = double(:consultation,
                            created_at: DateTime.new(2016, 1, 15, 11, 15, 0))
      presenter = described_class.new(consultation)
      expect(presenter.time).to eq('11:15 AM')
    end
  end

  describe '#pretty_date' do
    it 'returns the formatted consultation date' do
      created_at = DateTime.new(2016, 4, 13)
      consultation = double(:consultation, created_at: created_at)
      presenter = described_class.new(consultation)
      expect(I18n).to receive(:localize).with(created_at, format: '%B %d de %Y')
      presenter.pretty_date
    end
  end

  describe '#next_appointment_date' do
    it "returns the consultation's next appointment date" do
      consultation = double(:consultation, next_appointment: DateTime.new(2016, 1, 15))
      presenter = described_class.new(consultation)
      expect(presenter.next_appointment_date).to eq('2016-01-15')
    end
  end

  describe '#next_appointment_long_date' do
    it "returns the consultation's next appointment date" do
      consultation = double(:consultation, next_appointment: DateTime.new(2016, 1, 15))
      presenter = described_class.new(consultation)
      expect(presenter.next_appointment_long_date).to eq('Jan 15, 2016')
    end
  end

  describe '#next_appointment?' do
    context 'when there is next_appointment' do
      it 'returns true' do
        consultation = double(:consultation, next_appointment: double)
        presenter = described_class.new(consultation)
        expect(presenter.next_appointment?).to be_truthy
      end
    end

    context 'when there is no next_appointment' do
      it 'returns false' do
        consultation = double(:consultation, next_appointment: nil)
        presenter = described_class.new(consultation)
        expect(presenter.next_appointment?).to be_falsey
      end
    end
  end

  describe '#diagnoses?' do
    context 'when there are diagnoses' do
      it 'returns true' do
        consultation = double(:consultation, diagnoses: [double])
        presenter = described_class.new(consultation)
        expect(presenter.diagnoses?).to be_truthy
      end
    end

    context 'when there are no diagnoses' do
      it 'returns false' do
        consultation = double(:consultation, diagnoses: [])
        presenter = described_class.new(consultation)
        expect(presenter.diagnoses?).to be_falsey
      end
    end
  end

  describe '#prescriptions?' do
    context 'when there are prescriptions' do
      it 'returns true' do
        consultation = double(:consultation, prescriptions: [double])
        presenter = described_class.new(consultation)
        expect(presenter.prescriptions?).to be_truthy
      end
    end

    context 'when there are no prescriptions' do
      it 'returns false' do
        consultation = double(:consultation, prescriptions: [])
        presenter = described_class.new(consultation)
        expect(presenter.prescriptions?).to be_falsey
      end
    end
  end

  describe '#miscellaneous?' do
    context 'when miscellaneous is present' do
      it 'returns true' do
        consultation = double(:consultation, miscellaneous: 'extra notes')
        presenter = described_class.new(consultation)
        expect(presenter.miscellaneous?).to be_truthy
      end
    end

    context 'when miscellaneous is not present' do
      it 'returns false' do
        consultation = double(:consultation, miscellaneous: nil)
        presenter = described_class.new(consultation)
        expect(presenter.miscellaneous?).to be_falsey
      end
    end
  end
end
