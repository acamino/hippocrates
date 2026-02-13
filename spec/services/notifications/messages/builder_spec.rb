require 'rails_helper'

RSpec.describe Notifications::Messages::Builder do
  let(:patient) { create(:patient) }
  let(:consultation) { create(:consultation, patient: patient) }
  let(:user) { consultation.doctor }
  let(:payment_change) do
    consultation.current_user = user
    consultation.payment_changes.create!(
      previous_payment: 50.00,
      updated_payment: 75.00,
      reason: 'Ajuste de precio',
      type: :paid,
      user: user
    )
  end

  subject(:result) { described_class.new(payment_change).call }

  let(:email_subject) { result[0] }
  let(:email_body) { result[1] }

  it 'returns a subject and content pair' do
    expect(result).to be_an(Array)
    expect(result.length).to eq(2)
  end

  describe 'subject' do
    it 'includes the patient name' do
      expect(email_subject).to include(patient.full_name.upcase)
    end

    it 'includes the date' do
      expect(email_subject).to include(payment_change.created_at.strftime('%b %d, %Y'))
    end
  end

  describe 'content' do
    it 'includes the user name' do
      expect(email_body).to include(user.pretty_name.upcase)
    end

    it 'includes the patient name' do
      expect(email_body).to include(patient.full_name.upcase)
    end

    it 'includes the previous payment amount' do
      expect(email_body).to include('$50.00')
    end

    it 'includes the updated payment amount' do
      expect(email_body).to include('$75.00')
    end

    it 'includes the reason' do
      expect(email_body).to include('AJUSTE DE PRECIO')
    end

    it 'wraps content in HTML tags' do
      expect(email_body).to start_with('<html><body>')
      expect(email_body).to end_with('</body></html>')
    end

    it 'HTML-escapes user-provided content' do
      malicious_user = create(:user, pretty_name: '<script>alert("xss")</script>')
      consultation.current_user = malicious_user
      xss_change = consultation.payment_changes.create!(
        previous_payment: 10.00,
        updated_payment: 20.00,
        reason: '<img onerror=alert(1)>',
        type: :paid,
        user: malicious_user
      )

      _, body = described_class.new(xss_change).call

      expect(body).not_to include('<script>')
      expect(body).not_to include('<SCRIPT>')
      expect(body).not_to include('<img')
      expect(body).to include('&lt;')
      expect(body).to include('&gt;')
    end
  end
end
