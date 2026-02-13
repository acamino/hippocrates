require 'rails_helper'

RSpec.describe Activity do
  let(:user) { create(:user) }

  before do
    patient = create(:patient)
    patient.create_activity(:create, owner: user)
  end

  describe '.by_date' do
    it 'filters activities within the date range' do
      range = Date.today.beginning_of_day..Date.today.end_of_day

      expect(described_class.by_date(range)).not_to be_empty
    end

    it 'returns all when date is nil' do
      expect(described_class.by_date(nil).count).to eq(described_class.count)
    end
  end

  describe '.by_owner' do
    it 'filters activities by owner' do
      expect(described_class.by_owner(user.id)).not_to be_empty
    end

    it 'returns all when owner_id is nil' do
      expect(described_class.by_owner(nil).count).to eq(described_class.count)
    end
  end

  describe '.order_by_date' do
    it 'orders by created_at descending' do
      activities = described_class.order_by_date

      expect(activities).to eq(activities.sort_by(&:created_at).reverse)
    end
  end
end
