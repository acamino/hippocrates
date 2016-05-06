require 'rails_helper'

describe ConsultationsController do
  describe '#new' do
    let(:patient)      { double(:patient) }
    let(:consultation) { double(:consultation) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      allow(Consultation).to receive(:new) { consultation }
      get :new, patient_id: '1'
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @consultation' do
      expect(assigns(:consultation)).to eq(consultation)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end
end
