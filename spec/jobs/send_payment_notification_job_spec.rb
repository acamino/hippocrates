require 'rails_helper'

RSpec.describe SendPaymentNotificationJob, type: :job do
  let(:consultation) { create(:consultation) }
  let(:payment_change) do
    consultation.current_user = consultation.doctor
    consultation.payment_changes.create!(
      previous_payment: 50.00,
      updated_payment: 75.00,
      reason: 'Price adjustment',
      type: :paid,
      user: consultation.doctor
    )
  end

  describe '#perform' do
    it 'sends a notification via SendGrid' do
      sender = instance_double(Notifications::Sender, call: true)
      allow(Notifications::Sender).to receive(:new).and_return(sender)

      described_class.new.perform(payment_change.id)

      expect(Notifications::Sender).to have_received(:new).with(
        anything,
        anything
      )
      expect(sender).to have_received(:call)
    end

    it 'builds the message from the payment change' do
      sender = instance_double(Notifications::Sender, call: true)
      allow(Notifications::Sender).to receive(:new).and_return(sender)

      described_class.new.perform(payment_change.id)

      expect(Notifications::Sender).to have_received(:new) do |subject, message|
        expect(subject).to include(consultation.patient.full_name)
        expect(message).to include('html')
      end
    end
  end

  describe 'enqueuing' do
    it 'enqueues the job' do
      expect {
        described_class.perform_later(payment_change.id)
      }.to have_enqueued_job(described_class).with(payment_change.id)
    end
  end
end
