require 'rails_helper'

describe API::SettingsController do
  before { sign_in_user_mock }

  describe '#index' do
    before do
      create(:setting, name: 'name-1', value: '1')
      create(:setting, name: 'name-2', value: '2')

      get :index, format: :json
    end

    it 'formats the reponse as JSON' do
      diseases = ::JSON.parse(response.body)
      expect(diseases.last['value']).to eq('2')
    end

    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let!(:setting) { create(:setting, value: '1') }
    let(:value)    { '2' }

    before do
      patch :update, id: setting.id, value: value
    end

    context 'when the information is valid' do
      it 'updates setting' do
        expect(setting.reload.value).to eq('2')
      end

      it { is_expected.to respond_with :ok }
    end

    context 'when the information is invalid' do
      let(:value) { '' }

      it 'does not update the setting' do
        expect(setting.reload.value).to eq('1')
      end

      it { is_expected.to respond_with :unprocessable_entity }
    end
  end
end
