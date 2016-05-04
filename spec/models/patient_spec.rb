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
end
