require 'rails_helper'

RSpec.describe PatientPolicy do
  subject { described_class.new(user, build(:patient)) }

  context 'when the user is a regular user' do
    let(:user) { build(:user, admin: false, super_admin: false, doctor: false) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context 'when the user is an editor' do
    let(:user) { build(:user, admin: false, super_admin: false, doctor: false, editor: true) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context 'when the user is a doctor' do
    let(:user) { build(:user, admin: false, super_admin: false, doctor: true) }

    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is an admin' do
    let(:user) { build(:user, admin: true, super_admin: false, doctor: false) }

    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is a super_admin' do
    let(:user) { build(:user, admin: false, super_admin: true, doctor: false) }

    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user has can_delete_patients override' do
    let(:user) do
      build(:user, admin: false, super_admin: false, doctor: false, can_delete_patients: true)
    end

    it { is_expected.to permit_action(:destroy) }
  end
end
