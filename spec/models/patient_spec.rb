require 'rails_helper'

describe Patient do
  describe 'validations' do
    subject { build(:patient) }

    it { is_expected.to validate_presence_of :medical_history }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :identity_card_number }
    it { is_expected.to validate_presence_of :birthdate }
    it { is_expected.to validate_presence_of :gender }
    it { is_expected.to validate_presence_of :civil_status }
    it { is_expected.to validate_presence_of :source }

    it { is_expected.to validate_uniqueness_of :identity_card_number }
    it { is_expected.to validate_uniqueness_of :medical_history }
  end

  describe 'associations' do
    it { is_expected.to have_one(:anamnesis) }
  end

  describe '#age' do
    context 'when a patient has a birthdate' do
      subject { build(:patient, birthdate: Date.new(2011, 12, 8)) }

      it "calculates patient's age" do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(subject.age).to eq(3)
        end
      end
    end

    context "when a patient doesn't have a birthdate" do
      subject { Patient.new }

      it 'returns 0' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(subject.age).to eq(0)
        end
      end
    end
  end
end
