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

    it 'renders the :index template' do
      expect(response).to render_template(:index)
    end

    it 'responds with ok' do
      expect(response).to be_ok
    end
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

    it 'renders the :new template' do
      expect(response).to render_template(:new)
    end

    it 'responds with ok' do
      expect(response).to be_ok
    end
  end
end
