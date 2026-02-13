require 'rails_helper'

RSpec.describe 'Consultations::Documents', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /consultations/documents/download' do
    let(:consultation) { create(:consultation, :with_diagnoses) }

    before do
      template = double(:template)
      allow(Sablon).to receive(:template).and_return(template)
      allow(Consultations::Document).to receive(:build).and_return({})
      allow(template).to receive(:render_to_string).and_return('fake docx')
    end

    it 'returns a docx file attachment' do
      Timecop.freeze(Date.new(2015, 10, 21)) do
        get download_consultations_documents_path,
            params: { consultation_id: consultation.id,
                      certificate_type: 'simple' }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/msword')
      end
    end
  end
end
