require 'rails_helper'

describe Disease do
  describe 'validations' do
    subject { Disease.new(code: 'A001', name: 'disease') }

    it { is_expected.to validate_uniqueness_of :code }
  end
end
