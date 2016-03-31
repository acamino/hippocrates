require 'rails_helper'

describe PatientsController do
  describe '#index' do
    let(:patients) { [double(:patient)] }

    before do
      allow(Patient).to receive(:all) { patients }
      get :index
    end

    it 'assings @patients' do
      expect(assigns(:patients)).to eq(patients)
    end

    it { is_expected.to render_template :index }

    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    let(:patient) { double(:patient) }

    before do
      allow(Patient).to receive(:new) { patient }
      get :new
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it { is_expected.to render_template :new }

    it { is_expected.to respond_with :ok }
  end
end
