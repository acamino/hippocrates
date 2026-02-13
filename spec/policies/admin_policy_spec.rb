require 'rails_helper'

RSpec.describe AdminPolicy do
  subject { described_class.new(user, :admin) }

  context 'when the user is a regular user' do
    let(:user) { build(:user, admin: false, super_admin: false) }

    it { is_expected.to forbid_actions(%i[index show create update destroy export]) }
  end

  context 'when the user is an admin' do
    let(:user) { build(:user, admin: true, super_admin: false) }

    it { is_expected.to permit_actions(%i[index show create update destroy export]) }
  end

  context 'when the user is a super_admin' do
    let(:user) { build(:user, admin: false, super_admin: true) }

    it { is_expected.to permit_actions(%i[index show create update destroy export]) }
  end
end
