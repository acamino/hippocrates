require 'rails_helper'

describe Medicine do
  describe 'validations' do
    subject { Medicine.new(name: 'name', instructions: 'instructions') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :instructions }

    it { is_expected.to validate_uniqueness_of :name }
  end
end
