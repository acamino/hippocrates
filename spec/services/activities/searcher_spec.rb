require 'rails_helper'

describe Activities::Searcher do
  describe '.call' do
    context 'with a user id' do
      let!(:user)   { create(:user) }
      let!(:first)  { create(:activity, owner: user, key: 'anamnesis.viewed', created_at: '2022-09-0l') }
      let!(:second) { create(:activity, owner: user, key: 'anamnesis.edited', created_at: '2022-09-02') }

      before do
        first.update!(created_at: '2022-09-01')
        create(:activity, key: 'anamnesis.viewed', created_at: '2022-09-01')
        create(:activity, key: 'anamnesis.deleted', created_at: '2022-09-03')
      end

      it 'searches activities for the given date range' do
        result = described_class.new(user.id, Date.parse('2022-09-01'), Date.parse('2022-09-02')).call
        expect(result.to_a).to match([second, first])
      end
    end

    context 'without a user id' do
      let!(:first)  { create(:activity, key: 'anamnesis.viewed', created_at: '2022-09-0l') }
      let!(:second) { create(:activity, key: 'anamnesis.edited', created_at: '2022-09-02') }

      before do
        first.update!(created_at: '2022-09-01')
        create(:activity, key: 'anamnesis.deleted', created_at: '2022-09-03')
      end

      it 'searches activities for the given date range' do
        result = described_class.new(nil, Date.parse('2022-09-01'), Date.parse('2022-09-02')).call
        expect(result.to_a).to match([second, first])
      end
    end
  end
end
