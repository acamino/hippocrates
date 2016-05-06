require 'rails_helper'

describe Consultation do
  describe 'associations' do
    it { is_expected.to belong_to :patient }
  end
end
