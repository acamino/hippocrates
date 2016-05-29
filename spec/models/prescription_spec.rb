require 'rails_helper'

describe Prescription do
  describe 'validations' do
    it { is_expected.to validate_presence_of :inscription }
    it { is_expected.to validate_presence_of :subscription }
  end

  describe 'associations' do
    it { is_expected.to belong_to :consultation }
  end
end
