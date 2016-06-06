require 'rails_helper'

describe Anamnesis do
  describe 'associations' do
    it { is_expected.to belong_to(:patient) }
  end

  describe '#allergies?' do
    it 'returns true when allergies are not empty' do
      anamnesis = build(:anamnesis, allergies: 'PNC')
      expect(anamnesis.allergies?).to be_truthy
    end

    it 'returns false when allergies are empty' do
      anamnesis = build(:anamnesis, allergies: '')
      expect(anamnesis.allergies?).to be_falsey
    end
  end

  describe '#observations?' do
    it 'returns true when observations are not empty' do
      anamnesis = build(:anamnesis, observations: 'pnc')
      expect(anamnesis.observations?).to be_truthy
    end
  end

  describe '#personal_history?' do
    it 'returns true when personal_history is not empty' do
      anamnesis = build(:anamnesis, personal_history: 'pnc')
      expect(anamnesis.personal_history?).to be_truthy
    end
  end
end
