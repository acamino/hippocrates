require 'rails_helper'

describe Consultations::DocumentsController do
  before { sign_in_user_mock }

  describe '#download' do
    let(:template)     { double(:template) }
    let(:certificate)  { double(:certificate) }
    let(:consultation) { create(:consultation, :with_diagnoses) }
    let(:options) do
      {
        type: 'application/msword',
        disposition: 'attachment',
        filename: 'simple_richards_reed_2015_10_21_00_00_00.docx'
      }
    end

    before do
      expect(Sablon).to receive(:template) { template }
      expect(Consultations::Document).to receive(:build)
      expect(template).to receive(:render_to_string) { certificate }
      allow(controller).to receive(:send_data)
        .with(certificate, options) { controller.render body: nil }
    end

    it 'returns a docx file attachment' do
      Timecop.freeze(Date.new(2015, 10, 21)) do
        get :download, params: { consultation_id: consultation.id, certificate_type: 'simple' }

        expect(controller).to have_received(:send_data)
          .with(certificate, options).once
      end
    end
  end
end
