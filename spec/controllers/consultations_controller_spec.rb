require 'rails_helper'

describe ConsultationsController do
  let(:doctor) { create(:user) }

  before do
    create(:setting, :maximum_diagnoses)
    create(:setting, :maximum_prescriptions)

    sign_in_user_mock
  end

  describe '#index' do
    let(:patient) { create(:patient, :with_consultations) }

    before do
      get :index, params: { patient_id: patient.id }
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
    let(:patient) { create(:patient, :with_consultations) }

    before do
      get :new, params: { patient_id: patient.id }
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
    let(:doctor)  { create(:user) }
    let(:attributes_for_consultation) do
      attributes_for(:consultation)
        .merge(
          patient: { special: 'true' },
          user_id: doctor.id
        )
    end

    before do |example|
      allow(controller).to receive(:current_user) { doctor }

      unless example.metadata[:skip_on_before]
        post :create, params: { patient_id: patient.id.to_s,
                                consultation: attributes_for_consultation }
      end
    end

    it 'creates a new consultation', :skip_on_before do
      expect do
        post :create, params: { patient_id: patient.id.to_s,
                                consultation: attributes_for_consultation }
      end.to change { Consultation.count }.by(1)
    end

    it 'creates new diagnoses', :skip_on_before do
      pharyngitis = Disease.create(code: 'A001', name: 'Pharyngitis')
      rhinitis    = Disease.create(code: 'A002', name: 'Rhinitis')

      post :create, params: { patient_id: patient.id.to_s,
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
                                }
                              ) }

      expect(patient.consultations.last.diagnoses.count).to eq(2)
    end

    it 'creates new prescriptions', :skip_on_before do
      post :create, params: { patient_id: patient.id.to_s,
                              consultation: attributes_for_consultation.merge(
                                prescriptions_attributes: {
                                  '0' => { inscription: 'i1', subscription: 's1' },
                                  '1' => { inscription: 'i2', subscription: 's2' }
                                }
                              ) }

      expect(patient.consultations.last.prescriptions.count).to eq(2)
    end

    it "updates patient's special field", :skip_on_before do
      expect do
        post :create, params: { patient_id: patient.id.to_s,
                                consultation: attributes_for_consultation }
        patient.reload
      end.to change { patient.special }.from(false).to(true)
    end

    it 'redirects to edit consultations' do
      expect(response).to redirect_to edit_patient_consultation_path(
        patient.id, patient.most_recent_consultation.id
      )
    end

    it { is_expected.to respond_with :redirect }
  end

  describe '#edit' do
    let!(:patient)      { create(:patient) }
    let!(:consultation) { create(:consultation, patient: patient) }

    before do
      get :edit, params: { id: consultation.id,
                           patient_id: patient.id }
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
    let!(:consultation) do
      create(:consultation, patient: patient, created_at: '2020-10-16 18:01:00')
    end
    before do
      patch :update, params: { id: consultation.id,
                               patient_id: patient.id,
                               consultation: {
                                 reason: 'updated reason',
                                 hearing_aids: 'updated hearing aids',
                                 created_at: '2020-10-14',
                                 patient: { special: false }
                               } }
    end

    it 'updates consultation' do
      consultation.reload
      expect(consultation.reason).to eq('UPDATED REASON')
      expect(consultation.hearing_aids).to eq('UPDATED HEARING AIDS')
      expect(consultation.created_at).to eq('Wed, 14 Oct 2020 18:01:00 -05 -05:00')
    end

    it { is_expected.to redirect_to edit_patient_consultation_path(patient, consultation) }
  end
end
