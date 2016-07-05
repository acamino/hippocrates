require 'rails_helper'

describe CertificatesController do
  before { sign_in_user_mock }

  describe '#download' do
    let(:template)     { double(:template) }
    let(:certificate)  { double(:certificate) }
    let(:consultation) { create(:consultation, :with_diagnoses) }
    let(:options) do
      {
        type: 'application/msword',
        disposition: 'attachment',
        filename: 'certificate.docx'
      }
    end

    before do
      expect(Sablon).to receive(:template) { template }
      expect(template).to receive(:render_to_string) { certificate }

      allow(controller).to receive(:send_data)
        .with(certificate, options) { controller.render nothing: true }
    end

    it 'returns a docx file attachment' do
      get :download, consultation_id: consultation.id

      expect(controller).to have_received(:send_data)
        .with(certificate, options).once
    end
  end
end
