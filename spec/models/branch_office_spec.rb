require 'rails_helper'

RSpec.describe BranchOffice do
  describe 'associations' do
    it { is_expected.to have_many(:patients) }
    it { is_expected.to have_many(:consultations) }
  end

  describe 'validations' do
    subject { build(:branch_office) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'before_save :normalize' do
    it 'strips and upcases the name' do
      office = create(:branch_office, name: '  central office  ')

      expect(office.name).to eq('CENTRAL OFFICE')
    end
  end

  describe '.active' do
    it 'returns only active offices' do
      active   = create(:branch_office, active: true)
      _inactive = create(:branch_office, active: false)

      expect(described_class.active).to eq([active])
    end
  end

  describe '.search' do
    it 'returns all offices ordered by name when query is blank' do
      b = create(:branch_office, name: 'B Office')
      a = create(:branch_office, name: 'A Office')

      expect(described_class.search(nil)).to eq([a, b])
    end

    it 'filters by name when query is present' do
      match   = create(:branch_office, name: 'Downtown')
      _other  = create(:branch_office, name: 'Airport')

      expect(described_class.search('Downtown')).to eq([match])
    end
  end
end
