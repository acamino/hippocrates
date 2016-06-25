require 'rails_helper'

describe ConsultationsController do
  before { sign_in_user_mock }

  describe '#index' do
    let(:patient) { create(:patient, :with_consultations) }

    before do
      get :index, patient_id: patient.id
    end

    it 'assigns @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assigns @consultations' do
      expect(assigns(:consultations)).to eq(patient.consultations)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    let(:patient)      { double(:patient) }
    let(:consultation) { double(:consultation) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      get :new, patient_id: '1'
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @consultation' do
      expect(assigns(:consultation)).to be_a_new(Consultation)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    let(:patient) { create(:patient) }
    let(:attributes_for_consultation) do
      attributes_for(:consultation).merge(patient: { special: 'true' })
    end

    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, patient_id: patient.id.to_s,
                      consultation: attributes_for_consultation
      end
    end

    it 'creates a new consultation', :skip_on_before do
      expect do
        post :create, patient_id: patient.id.to_s,
                      consultation: attributes_for_consultation
      end.to change { Consultation.count }.by(1)
    end

    it 'creates new diagnoses', :skip_on_before do
      pharyngitis = Disease.create(code: 'A001', name: 'Pharyngitis')
      rhinitis    = Disease.create(code: 'A002', name: 'Rhinitis')

      post :create, patient_id: patient.id.to_s,
                    consultation: attributes_for_consultation.merge(
                      diagnoses_attributes: {
                        '0' => {
                          disease_code: pharyngitis.code,
                          description: pharyngitis.name,
                          type: 'presuntive'
                        },
                        '1' => {
                          disease_code: rhinitis.code,
                          description: rhinitis.name,
                          type: 'presuntive'
                        }
                      })

      expect(patient.consultations.last.diagnoses.count).to eq(2)
    end

    it 'creates new prescriptions', :skip_on_before do
      post :create, patient_id: patient.id.to_s,
                    consultation: attributes_for_consultation.merge(
                      prescriptions_attributes: {
                        '0' => { inscription: 'inscription-one', subscription: 'subscription' },
                        '1' => { inscription: 'inscription-two', subscription: 'subscription' }
                      })

      expect(patient.consultations.last.prescriptions.count).to eq(2)
    end

    it "updates patient's special field", :skip_on_before do
      expect do
        post :create, patient_id: patient.id.to_s,
                      consultation: attributes_for_consultation
        patient.reload
      end.to change { patient.special }.from(false).to(true)
    end

    it 'redirects to edit consultations' do
      expect(response).to redirect_to edit_patient_consultation_path(
        patient.id, patient.consultations.most_recent.id)
    end

    it { is_expected.to respond_with :redirect }
  end

  describe '#edit' do
    let!(:patient)      { create(:patient) }
    let!(:consultation) { create(:consultation, patient: patient) }

    before do
      get :edit, id: consultation.id,
                 patient_id: patient.id
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @consultation' do
      expect(assigns(:consultation)).to eq(consultation)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let!(:patient)      { create(:patient) }
    let!(:consultation) { create(:consultation, patient: patient) }
    before do
      patch :update, id: consultation.id,
                     patient_id: patient.id,
                     consultation: {
                       reason: 'updated reason', patient: { special: false }
                     }
    end

    it 'updates consultation' do
      expect(consultation.reload.reason).to eq('UPDATED REASON')
    end

    it { is_expected.to redirect_to patients_path }
    it { is_expected.to respond_with :redirect }
  end
end
