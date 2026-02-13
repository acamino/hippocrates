require 'rails_helper'

describe DocumentsController do
  before { sign_in_user_mock }

  let(:patient) { create(:patient) }
  let(:consultation) { create(:consultation, patient: patient) }

  describe '#index' do
    before do
      consultation.documents.create!(description: 'test doc')
      get :index, params: { patient_id: patient.id, consultation_id: consultation.id }
    end

    it 'assigns @documents' do
      expect(assigns(:documents)).not_to be_empty
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before do
      get :new, params: { patient_id: patient.id, consultation_id: consultation.id }
    end

    it 'assigns @document' do
      expect(assigns(:document)).to be_a_new(Document)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    context 'when the information is valid' do
      it 'creates a document' do
        expect {
          post :create, params: {
            patient_id: patient.id,
            consultation_id: consultation.id,
            document: { description: 'Lab results' }
          }
        }.to change(Document, :count).by(1)
      end

      it 'redirects to documents index' do
        post :create, params: {
          patient_id: patient.id,
          consultation_id: consultation.id,
          document: { description: 'Lab results' }
        }

        is_expected.to redirect_to patient_consultation_documents_path(patient, consultation)
      end
    end

    context 'when the information is invalid' do
      it 'does not create a document' do
        expect {
          post :create, params: {
            patient_id: patient.id,
            consultation_id: consultation.id,
            document: { description: '' }
          }
        }.not_to change(Document, :count)
      end

      it 'renders new' do
        post :create, params: {
          patient_id: patient.id,
          consultation_id: consultation.id,
          document: { description: '' }
        }

        is_expected.to render_template :new
      end
    end
  end

  describe '#edit' do
    let(:document) { consultation.documents.create!(description: 'test') }

    before do
      get :edit, params: {
        patient_id: patient.id,
        consultation_id: consultation.id,
        id: document.id
      }
    end

    it 'assigns @document' do
      expect(assigns(:document)).to eq(document)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:document) { consultation.documents.create!(description: 'old') }

    context 'when the information is valid' do
      before do
        put :update, params: {
          patient_id: patient.id,
          consultation_id: consultation.id,
          id: document.id,
          document: { description: 'updated' }
        }
      end

      it 'updates the document' do
        expect(document.reload.description).to eq('UPDATED')
      end

      it { is_expected.to redirect_to patient_consultation_documents_path(patient, consultation) }
    end

    context 'when the information is invalid' do
      before do
        put :update, params: {
          patient_id: patient.id,
          consultation_id: consultation.id,
          id: document.id,
          document: { description: '' }
        }
      end

      it { is_expected.to render_template :edit }
    end
  end

  describe '#destroy' do
    let!(:document) { consultation.documents.create!(description: 'to delete') }

    it 'deletes the document' do
      expect {
        delete :destroy, params: {
          patient_id: patient.id,
          consultation_id: consultation.id,
          id: document.id
        }
      }.to change(Document, :count).by(-1)
    end

    it 'redirects to documents index' do
      delete :destroy, params: {
        patient_id: patient.id,
        consultation_id: consultation.id,
        id: document.id
      }

      is_expected.to redirect_to patient_consultation_documents_path(patient, consultation)
    end
  end
end
