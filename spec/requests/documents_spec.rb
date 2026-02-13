require 'rails_helper'

RSpec.describe 'Documents', type: :request do
  before { login_as create(:user), scope: :user }

  let(:patient) { create(:patient) }
  let(:consultation) { create(:consultation, patient: patient) }

  describe 'GET /patients/:patient_id/consultations/:consultation_id/documents' do
    before do
      consultation.documents.create!(description: 'test doc')
      get patient_consultation_documents_path(patient, consultation)
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /patients/:pid/consultations/:cid/documents/new' do
    before do
      get new_patient_consultation_document_path(patient, consultation)
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /patients/:pid/consultations/:cid/documents' do
    context 'when the information is valid' do
      it 'creates a document' do
        expect do
          post patient_consultation_documents_path(patient, consultation),
               params: { document: { description: 'Lab results' } }
        end.to change(Document, :count).by(1)
      end

      it 'redirects to documents index' do
        post patient_consultation_documents_path(patient, consultation),
             params: { document: { description: 'Lab results' } }

        expect(response).to redirect_to(
          patient_consultation_documents_path(patient, consultation)
        )
      end
    end

    context 'when the information is invalid' do
      it 'does not create a document' do
        expect do
          post patient_consultation_documents_path(patient, consultation),
               params: { document: { description: '' } }
        end.not_to change(Document, :count)
      end

      it 're-renders new' do
        post patient_consultation_documents_path(patient, consultation),
             params: { document: { description: '' } }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /patients/:pid/consultations/:cid/documents/:id/edit' do
    let(:document) { consultation.documents.create!(description: 'test') }

    before do
      get edit_patient_consultation_document_path(
        patient, consultation, document
      )
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PUT /patients/:pid/consultations/:cid/documents/:id' do
    let(:document) { consultation.documents.create!(description: 'old') }

    context 'when the information is valid' do
      before do
        put patient_consultation_document_path(
          patient, consultation, document
        ), params: { document: { description: 'updated' } }
      end

      it 'updates the document' do
        expect(document.reload.description).to eq('UPDATED')
      end

      it do
        expect(response).to redirect_to(
          patient_consultation_documents_path(patient, consultation)
        )
      end
    end

    context 'when the information is invalid' do
      before do
        put patient_consultation_document_path(
          patient, consultation, document
        ), params: { document: { description: '' } }
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE /patients/:pid/consultations/:cid/documents/:id' do
    let!(:document) do
      consultation.documents.create!(description: 'to delete')
    end

    it 'deletes the document' do
      expect do
        delete patient_consultation_document_path(
          patient, consultation, document
        )
      end.to change(Document, :count).by(-1)
    end

    it 'redirects to documents index' do
      delete patient_consultation_document_path(
        patient, consultation, document
      )

      expect(response).to redirect_to(
        patient_consultation_documents_path(patient, consultation)
      )
    end
  end
end
