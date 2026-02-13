require 'rails_helper'

RSpec.describe Charges::Searcher do
  let(:doctor) { create(:user, doctor: true) }
  let(:branch_office) { create(:branch_office) }
  let(:date_range) { Date.today.beginning_of_day..Date.today.end_of_day }

  let!(:consultation) do
    create(:consultation, doctor: doctor, branch_office: branch_office)
  end

  describe '.call' do
    it 'returns consultations within the date range' do
      results = described_class.call(nil, nil, date_range)

      expect(results).to include(consultation)
    end

    it 'filters by user when uid is present' do
      other_doctor = create(:user, doctor: true)
      create(:consultation, doctor: other_doctor)

      results = described_class.call(doctor.id, nil, date_range)

      expect(results).to eq([consultation])
    end

    it 'filters by branch office when bid is present' do
      other_office = create(:branch_office)
      create(:consultation, branch_office: other_office)

      results = described_class.call(nil, branch_office.id, date_range)

      expect(results).to eq([consultation])
    end

    it 'excludes discarded consultations' do
      consultation.discard

      results = described_class.call(nil, nil, date_range)

      expect(results).to be_empty
    end

    it 'returns all when filters are nil' do
      results = described_class.call(nil, nil, nil)

      expect(results).to include(consultation)
    end
  end
end
