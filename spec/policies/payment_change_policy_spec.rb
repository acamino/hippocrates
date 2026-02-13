require 'rails_helper'

RSpec.describe PaymentChangePolicy do
  subject { described_class.new(user, PaymentChange) }

  context 'when the user is a regular user' do
    let(:user) { build(:user, admin: false, super_admin: false, doctor: false) }

    it { is_expected.to forbid_action(:create) }
  end

  context 'when the user is a doctor' do
    let(:user) { build(:user, admin: false, super_admin: false, doctor: true) }

    it { is_expected.to permit_action(:create) }
  end

  context 'when the user is an admin' do
    let(:user) { build(:user, admin: true, super_admin: false, doctor: false) }

    it { is_expected.to permit_action(:create) }
  end

  context 'when the user is a super_admin' do
    let(:user) { build(:user, admin: false, super_admin: true, doctor: false) }

    it { is_expected.to permit_action(:create) }
  end
end
