require 'rails_helper'

RSpec.describe Charts::Payments::Builder do
  let(:date_range) { Date.today.beginning_of_day..Date.today.end_of_day }

  before do
    create(:consultation, payment: 100.00, pending_payment: 25.00)
  end

  describe '#call' do
    subject(:result) { described_class.new(date_range, nil, nil).call }

    it 'returns an array with two series' do
      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
    end

    it 'includes Valores Pagados series' do
      expect(result.first[:name]).to eq('Valores Pagados')
    end

    it 'includes Valores Pendientes series' do
      expect(result.second[:name]).to eq('Valores Pendientes')
    end

    it 'sums payment amounts by day' do
      expect(result.first[:data]).to be_a(Hash)
    end

    it 'sums pending payment amounts by day' do
      expect(result.second[:data]).to be_a(Hash)
    end
  end
end
