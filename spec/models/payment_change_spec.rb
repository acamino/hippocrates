require 'rails_helper'

RSpec.describe PaymentChange do
  let(:doctor) { create(:user, doctor: true) }
  let(:consultation) do
    c = create(:consultation, doctor: doctor, payment: 50.00)
    c.current_user = doctor
    c
  end

  subject do
    consultation.payment_changes.build(
      previous_payment: 50, updated_payment: 75,
      reason: 'test', type: :paid, user: doctor
    )
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }

    it 'belongs to a consultation' do
      expect(subject.consultation).to eq(consultation)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:previous_payment) }
    it { is_expected.to validate_presence_of(:updated_payment) }
    it { is_expected.to validate_presence_of(:reason) }

    context 'when the current user is a doctor' do
      it 'requires updated_payment to be greater than 0' do
        change = consultation.payment_changes.build(
          previous_payment: 50, updated_payment: 0,
          reason: 'test', type: :paid, user: doctor
        )

        expect(change).not_to be_valid
        expect(change.errors[:updated_payment]).to be_present
      end
    end

    context 'when the current user is an admin (not a doctor)' do
      let(:admin) { create(:user, admin: true, doctor: false) }

      it 'allows updated_payment of 0' do
        consultation.current_user = admin
        change = consultation.payment_changes.build(
          previous_payment: 50, updated_payment: 0,
          reason: 'test', type: :paid, user: admin
        )

        expect(change).to be_valid
      end
    end
  end

  describe 'enum' do
    it { is_expected.to define_enum_for(:type).with_values(paid: 0, pending: 1) }
  end

  describe 'before_save :normalize' do
    it 'strips and upcases the reason' do
      change = consultation.payment_changes.create!(
        previous_payment: 50, updated_payment: 75,
        reason: '  price adjustment  ', type: :paid, user: doctor
      )

      expect(change.reason).to eq('PRICE ADJUSTMENT')
    end
  end

  describe 'after_save :update_consultation' do
    context 'when type is paid' do
      it 'updates the consultation payment' do
        consultation.payment_changes.create!(
          previous_payment: 50, updated_payment: 100,
          reason: 'test', type: :paid, user: doctor
        )

        expect(consultation.reload.payment).to eq(100)
      end
    end

    context 'when type is pending' do
      it 'updates the consultation pending_payment' do
        consultation.payment_changes.create!(
          previous_payment: 0, updated_payment: 30,
          reason: 'test', type: :pending, user: doctor
        )

        expect(consultation.reload.pending_payment).to eq(30)
      end
    end
  end
end
