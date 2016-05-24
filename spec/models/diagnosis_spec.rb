require 'rails_helper'

describe Diagnosis do
  describe 'associations' do
    it { is_expected.to belong_to :consultation }
  end
end
