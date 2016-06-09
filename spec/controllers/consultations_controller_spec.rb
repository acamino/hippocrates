require 'rails_helper'

describe ConsultationsController do
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
    let(:patient)                     { create(:patient) }
    let(:attributes_for_consultation) do
      attributes_for(:consultation).merge(patient: { special: '1' })
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
            '0': { disease_code: pharyngitis.code, description: pharyngitis.name, type: 'presuntive' },
            '1': { disease_code: rhinitis.code, description: rhinitis.name, type: 'presuntive' },
          })

      expect(patient.consultations.last.diagnoses.count).to eq(2)
    end

    it 'creates new prescriptions', :skip_on_before do
      post :create, patient_id: patient.id.to_s,
        consultation: attributes_for_consultation.merge(
          prescriptions_attributes: {
            '0': { inscription: 'inscription-one', subscription: 'subscription' },
            '1': { inscription: 'inscription-two', subscription: 'subscription' },
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

    it { is_expected.to redirect_to patients_path }
    it { is_expected.to respond_with :redirect }
  end
end
