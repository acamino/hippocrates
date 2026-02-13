require 'rails_helper'

RSpec.describe Charts::Consultations::Builder do
  let(:date_range) { Date.today.beginning_of_day..Date.today.end_of_day }

  before { create(:consultation) }

  describe '#call' do
    subject(:result) { described_class.new(date_range, nil, nil).call }

    it 'returns an array with one series' do
      expect(result).to be_an(Array)
      expect(result.length).to eq(1)
    end

    it 'names the series Consultas' do
      expect(result.first[:name]).to eq('Consultas')
    end

    it 'groups consultation counts by day' do
      expect(result.first[:data]).to be_a(Hash)
      expect(result.first[:data].values.sum).to be >= 1
    end

    it 'filters by user when uid is provided' do
      doctor = create(:user, doctor: true)
      create(:consultation, doctor: doctor)

      result = described_class.new(date_range, doctor.id, nil).call

      expect(result.first[:data].values.sum).to eq(1)
    end
  end
end
