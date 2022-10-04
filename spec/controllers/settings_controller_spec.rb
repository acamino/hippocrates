require 'rails_helper'

describe SettingsController do
  before { sign_in_user_mock }

  describe '#index' do
    let!(:maximum_diagnoses)        { create(:setting, :maximum_diagnoses) }
    let!(:maximum_prescriptions)    { create(:setting, :maximum_prescriptions) }
    let!(:medical_history_sequence) { create(:setting, :medical_history_sequence) }
    let!(:emergency_number)         { create(:setting, :emergency_number) }

    before { get :index }

    it 'assigns @maximum_diagnoses' do
      expect(assigns(:maximum_diagnoses)).to eq(maximum_diagnoses)
    end

    it 'assigns @maximum_prescriptions' do
      expect(assigns(:maximum_prescriptions)).to eq(maximum_prescriptions)
    end

    it 'assigns @medical_history_sequence' do
      expect(assigns(:medical_history_sequence)).to eq(medical_history_sequence)
    end

    it 'assigns @emergency_number' do
      expect(assigns(:emergency_number)).to eq(emergency_number)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end
end
