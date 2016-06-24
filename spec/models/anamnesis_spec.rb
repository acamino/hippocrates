require 'rails_helper'

describe Anamnesis do
  describe 'associations' do
    it { is_expected.to belong_to(:patient) }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      anamnesis = create(:anamnesis, medical_history: 'medical history')
      expect(anamnesis.reload.medical_history).to eq('MEDICAL HISTORY')
    end
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
      anamnesis = build(:anamnesis, observations: 'observations')
      expect(anamnesis.observations?).to be_truthy
    end
  end

  describe '#medical_history?' do
    it 'returns true when medical history is not empty' do
      anamnesis = build(:anamnesis, medical_history: 'medical history')
      expect(anamnesis.medical_history?).to be_truthy
    end
  end
end
