require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_uniqueness_of :registration_acess }
  end

  describe '.next_serial!' do
    let(:user) { create(:user, serial: 1) }

    it 'finds the next serial' do
      expect do
        expect(user.next_serial!).to eq(2)
      end.to change(user, :serial).from(1).to(2)
    end
  end

  describe '.admin_or_super_admin?' do
    let(:user) { build(:user, admin: admin, super_admin: super_admin) }

    subject { user.admin_or_super_admin? }

    context 'when the user is admin' do
      let(:admin)       { true }
      let(:super_admin) { false }

      it { is_expected.to be_truthy }
    end
    context 'when the user is super admin' do
      let(:admin)       { false }
      let(:super_admin) { true }

      it { is_expected.to be_truthy }
    end
    context 'when the user is not admin or super admin' do
      let(:admin)       { false }
      let(:super_admin) { false }

      it { is_expected.to be_falsey }
    end
  end
end
