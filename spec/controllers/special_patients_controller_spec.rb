require 'rails_helper'

describe SpecialPatientsController do
  before { sign_in_user_mock }

  describe '#index' do
    let!(:bob_consultation) do
      create(:patient, :special, :with_consultations).most_recent_consultation
    end
    let!(:alice_consultation) do
      create(:patient, :with_consultations).most_recent_consultation
    end

    before { get :index }

    it 'assings sorted by most recent consultations for special patients' do
      expect(assigns(:consultations)).to eq([bob_consultation])
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#remove' do
    let!(:patient) { create(:patient, :special) }

    before do |example|
      delete :remove, params: { id: patient.id } unless example.metadata[:skip_on_before]
    end

    it 'removes patient from special', :skip_on_before do
      expect do
        delete :remove, params: { id: patient.id }
      end.to change { patient.reload.special }.from(true).to(false)
    end

    it { is_expected.to redirect_to special_patients_path }
  end
end
