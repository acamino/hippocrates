require 'rails_helper'

describe Consultation do
  describe 'associations' do
    it { is_expected.to belong_to :patient }
    it { is_expected.to have_many(:diagnoses) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:diagnoses).allow_destroy(true) }
  end
end
